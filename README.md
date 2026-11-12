# ADC SAR de 8 bits en SKY130A (`ADCMOS`)

Diseño a nivel de transistor y verificación física de un **Convertidor Analógico-Digital de Aproximaciones Sucesivas (SAR ADC) de 8 bits** en tecnología **SkyWater 130 nm (`SKY130A`)**, orientado a integración en la plantilla analógica de **Tiny Tapeout** ($1 \times 2$ tiles).

* **Versión de especificación:** v0.2 (29 de octubre de 2026)
* **Curso:** Proyecto Semestral de CMOS Analógico — 2026
* **Integrantes:** Daniel Guerrero, Isaías Gallardo, Juan David Gómez

---

## 1. Especificaciones Objetivo

| Parámetro | Meta de Diseño | Condiciones de Evaluación |
| :--- | :--- | :--- |
| **Resolución ($N$)** | $8\text{ bits}$ ($256$ códigos) | $V_{FS} = V_{REF} = 1,2\text{ V}$; $1\text{ LSB} = 4,69\text{ mV}$ |
| **Frecuencia de muestreo ($f_s$)** | $\ge 1\text{ MS/s}$ | $f_{clk} = 10\text{ MHz}$ ($10\text{ ciclos/conversión}$) |
| **Rango de entrada ($V_{IN}$)** | $0\text{ V} \text{ a } 1,2\text{ V}$ | Entrada simple (*single-ended*) |
| **Linealidad estática** | $DNL \le \pm 0,5\text{ LSB}$, $INL \le \pm 1\text{ LSB}$ | Sin códigos perdidos; offset y ganancia $\le \pm 2\text{ LSB}$ ($3\sigma$) |
| **Precisión dinámica** | $SNDR \ge 43,9\text{ dB}$ ($ENOB \ge 7,0$) | FFT de 1024 puntos coherentes ($f_{in} \approx 124\text{ kHz}$, $-0,5\text{ dBFS}$); $ENOB \ge 6,5$ a $497\text{ kHz}$ |
| **Consumo del núcleo ($P_{avg}$)** | $\le 100\ \mu\text{W}$ ($I_{DD} \le 56\ \mu\text{A}$) | $V_{DD} = 1,8\text{ V}$ (analógico + digital, sin buffers de salida de $10\text{ pF}$) |
| **Figura de Mérito ($FoM_W$)** | $\le 1\text{ pJ/paso}$ | $FoM_W = P_{avg} / (2^{ENOB} \cdot f_s)$ |
| **Área estimada** | $\approx 10\,000\ \mu\text{m}^2$ ($< 30\%$ plantilla) | Plantilla Tiny Tapeout $1 \times 2$ ($\approx 160 \times 225\ \mu\text{m} \approx 36\,000\ \mu\text{m}^2$) |

---

## 2. Arquitectura del Sistema

El convertidor se divide en tres bloques funcionales con interfaces estandarizadas:

1. **Bloque B1 — Muestreo y CDAC Binario:**
   * Arreglo capacitivo binario de 8 bits ($1C_u \dots 128C_u$) + capacitor *dummy* de $1C_u$ ($C_u = 20\text{ fF}$, $C_{\text{total}} = 5,12\text{ pF}$) implementado con celdas unitarias idénticas de capacitor MIM `sky130_fd_pr__cap_mim_m3_1` ($\text{met3–met4}$).
   * Con densidad nominal de $2,0\text{ fF}/\mu\text{m}^2$ y término de perímetro de $\approx 0,19\text{ fF}/\mu\text{m}$, cada unidad ocupa $A_u \approx 8,9\ \mu\text{m}^2$ ($\approx 3\ \mu\text{m} \times 3\ \mu\text{m}$), logrando $\sigma_u \approx 0,94\% < 1\%$.
   * Durante `SAMPLE = 1`, el plato superior se polariza a $V_{cm} = V_{REF}/2 \approx 0,6\text{ V}$ (generado mediante divisor resistivo interno `res_xhigh_po_0p69`) y los platos inferiores siguen a $V_{IN}$ ($R_{sw} \le 1\text{ k}\Omega$, $\tau \le 5\text{ ns}$). Asentamiento del DAC $\le 30\text{ ns}$ a $0,5\text{ LSB}$ e inyección de carga $\le 0,25\text{ LSB}$.
2. **Bloque B2 — Comparador Dinámico StrongARM:**
   * Par diferencial de entrada NMOS dimensionado por Pelgrom para mantener $\sigma_{\text{os}} \le 1\text{ mV}$ y ruido de entrada $\le 0,5\text{ mV}_{\text{rms}}$.
   * Evaluación por flanco de bajada de `CLK_CMP` ($t_{\text{dec}} < 10\text{ ns}$ con $\Delta V = 0,5\text{ LSB}$, energía $\le 0,3\text{ pJ/decisión}$) y *latch* regenerativo con salida digital a $1,8\text{ V}$.
3. **Bloque B3 — Lógica SAR y Secuenciador Síncrono:**
   * Máquina síncrona de 10 estados a $10\text{ MHz}$ con celdas estándar `sky130_fd_sc_hd` (consumo digital $\le 40\ \mu\text{W}$): 1 ciclo de muestreo (`SAMPLE`), 8 ciclos de aproximación sucesiva (`S[7:0]`) y 1 ciclo de salida válida (`EOC`). Compatible con el límite de E/S de Tiny Tapeout ($\approx 66\text{ MHz}$, retardo de pad $\le 10\text{ ns}$).

### Asignación de Pines (Tiny Tapeout)

| Señal | Pin Plantilla | Dirección | Nivel | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `VIN` | `ua[0]` | Entrada analógica | $0\text{–}1,2\text{ V}$ | Señal analógica a convertir ($R_{\text{pad}} < 500\ \Omega$, $C_{\text{pad}} < 5\text{ pF}$) |
| `VREF` | `ua[1]` | Entrada analógica | $1,2\text{ V}$ DC $\pm 5\text{ mV}$ | Tensión de referencia externa con desacople en placa (`ua[3]` reservado para ATB opcional) |
| `clk` | `clk` | Entrada digital | $0 / 1,8\text{ V}$ | Reloj principal del sistema ($10\text{ MHz}$, $50\%$ duty cycle) |
| `rst_n` | `rst_n` | Entrada digital | $0 / 1,8\text{ V}$ | Reinicio maestro activo en bajo |
| `START` | `ui_in[0]` | Entrada digital | $0 / 1,8\text{ V}$ | Pulso $\ge 1$ ciclo para iniciar la conversión |
| `D[7:0]` | `uo_out[7:0]` | Salida digital | $0 / 1,8\text{ V}$ | Palabra binaria de salida (válida cuando `EOC = 1`) |
| `EOC` | `uio[0]` | Salida digital | $0 / 1,8\text{ V}$ | Fin de conversión (*End of Conversion*, 1 ciclo) |
| `SAMPLE` / `CMP` | `uio[1]` / `uio[2]` | Salidas digitales | $0 / 1,8\text{ V}$ | Diagnóstico de fase de muestreo y salida del comparador |

---

## 3. Estructura del Repositorio

```text
ADCMOS/
├── schematics/
│   ├── B1_cdac/          # Esquemáticos del CDAC, switches de muestreo, drivers y divisor Vcm
│   ├── B2_comp/          # Esquemático del comparador dinámico StrongARM y SR-latch
│   ├── B3_logic/         # Lógica SAR síncrona y secuenciador de 10 estados
│   └── top/              # Ensamblaje completo del ADC SAR de 8 bits
├── tb/
│   ├── B1/               # Testbenches de caracterización AC, OP, asentamiento y Monte Carlo del CDAC
│   ├── B2/               # Testbenches de tiempo de decisión, energía, ruido y offset
│   ├── B3/               # Testbench funcional y de temporización a 10 MHz en ss/LV/hot
│   └── top/              # Testbenches de rampa (DNL/INL) y senoide coherente (FFT/ENOB)
├── simulations/
│   ├── run_pvt.spice     # Script maestro de barrido PVT y esquinas combinadas
│   ├── run_mc.spice      # Script de simulación Monte Carlo de desajuste (tt_mm, >= 100 corridas)
│   └── pvt_results/      # Resultados numéricos y logs
├── xschemrc              # Configuración local de librerías SKY130A para Xschem
├── .magicrc              # Configuración tecnológica SKY130A para Magic
└── README.md             # Documentación principal del proyecto
```

---

## 4. Configuración del Entorno EDA

### Requisitos de Software
* **PDK:** `sky130A` gestionado vía `volare` (hash habilitado: `c6d73a35f524070e85faff4a6a9eef49553ebc2b`, 53 secciones `.lib` verificadas).
* **Magic:** Versión $\ge 8.3.411$ (requerida por `sky130A.tech`).
* **Xschem, ngspice y Netgen:** Instalados y disponibles en el `PATH`.

### Inicialización de Variables de Entorno
Antes de abrir Xschem, Magic o ejecutar simulaciones, exportar las rutas del PDK:

```bash
export PDK_ROOT="$HOME/.volare"
export PDK="sky130A"
export PDKPATH="$HOME/.volare/sky130A"
```

---

## 5. Protocolo de Simulación y Matriz PVT

Todos los bloques y el sistema completo se verifican mediante análisis de punto de operación (`.op`), respuesta en frecuencia (`.ac` sobre el camino de muestreo) y transitorio (`.tran`) bajo la siguiente matriz de condiciones (respetando el límite SOA de $1,95\text{ V}$ de los modelos de $1,8\text{ V}$):

| Escenario | Tensión $V_{DD}$ | Temperatura ($T$) | Esquinas de Proceso (`sky130.lib.spice`) |
| :--- | :--- | :--- | :--- |
| **Nominal** | $1,80\text{ V}$ | $27^\circ\text{C}$ | `tt` |
| **HV–hot** | $1,95\text{ V}$ ($+8,3\%$) | $85^\circ\text{C}$ | `tt`, `ff`, `sf`, `fs`, `ff_ll` |
| **HV–cold** | $1,95\text{ V}$ ($+8,3\%$) | $-40^\circ\text{C}$ | `tt`, `ff`, `ff_ll` |
| **LV–hot** | $1,62\text{ V}$ ($-10\%$) | $85^\circ\text{C}$ | `tt`, `ss`, `sf`, `fs`, `ss_hh` |
| **LV–cold** | $1,62\text{ V}$ ($-10\%$) | $-40^\circ\text{C}$ | `tt`, `ss`, `ss_hh` |
| **Desajuste (MC)** | $1,80\text{ V}$ | $27^\circ\text{C}$ | `tt_mm` ($\ge 100$ corridas Monte Carlo) |

### Ejecución Automatizada en `ngspice`

1. **Barrido de esquinas PVT (incluyendo `ss_hh` y `ff_ll` para el CDAC):**
   ```bash
   cd simulations
   for corner in tt ss ff sf fs ss_hh ff_ll; do
     sed "s/\.lib .* sky130\.lib\.spice .*/.lib \$PDK_ROOT\/\$PDK\/libs.tech\/ngspice\/sky130.lib.spice $corner/" run_pvt.spice > run_${corner}.spice
     ngspice -b run_${corner}.spice -o pvt_results/log_${corner}.log
   done
   ```

2. **Simulación Monte Carlo de desajuste (`tt_mm`):**
   ```bash
   ngspice -b run_mc.spice -o pvt_results/log_mc_tt_mm.log
   ```
