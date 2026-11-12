# ADC SAR de 8 bits en SKY130A (`ADCMOS`)

Diseño a nivel de transistor y verificación física de un **Convertidor Analógico-Digital de Aproximaciones Sucesivas (SAR ADC) de 8 bits** en tecnología **SkyWater 130 nm (`SKY130A`)**, orientado a integración en la plantilla analógica de **Tiny Tapeout** ($1 \times 2$ tiles).

* **Curso:** Proyecto Semestral de CMOS Analógico — 2026
* **Integrantes:** Daniel Guerrero, Isaías Gallardo, Juan David Gómez

---

## 1. Especificaciones Objetivo

| Parámetro | Meta de Diseño | Condiciones de Evaluación |
| :--- | :--- | :--- |
| **Resolución ($N$)** | $8\text{ bits}$ ($256$ códigos) | $V_{FS} = V_{REF} = 1,2\text{ V}$; $1\text{ LSB} = 4,69\text{ mV}$ |
| **Frecuencia de muestreo ($f_s$)** | $\ge 1\text{ MS/s}$ | $f_{clk} = 10\text{ MHz}$ ($10\text{ ciclos/conversión}$) |
| **Rango de entrada ($V_{IN}$)** | $0\text{ V} \text{ a } 1,2\text{ V}$ | Entrada simple (*single-ended*) |
| **Linealidad estática** | $DNL \le \pm 0,5\text{ LSB}$, $INL \le \pm 1\text{ LSB}$ | Sin códigos perdidos; offset y ganancia $\le \pm 2\text{ LSB}$ |
| **Precisión dinámica** | $SNDR \ge 43,9\text{ dB}$ ($ENOB \ge 7,0$) | FFT de 1024 puntos coherentes ($f_{in} \approx 124\text{ kHz}$, $-0,5\text{ dBFS}$) |
| **Consumo del núcleo ($P_{avg}$)** | $\le 100\ \mu\text{W}$ ($I_{DD} \le 56\ \mu\text{A}$) | $V_{DD} = 1,8\text{ V}$ (excluyendo buffers de salida de $10\text{ pF}$) |
| **Figura de Mérito ($FoM_W$)** | $\le 1\text{ pJ/paso}$ | $FoM_W = P_{avg} / (2^{ENOB} \cdot f_s)$ |
| **Área estimada** | $\approx 10\,000\ \mu\text{m}^2$ ($\sim 28\%$ plantilla) | Plantilla Tiny Tapeout $1 \times 2$ ($160 \times 225\ \mu\text{m}$) |

---

## 2. Arquitectura del Sistema

El convertidor se divide en tres bloques funcionales con interfaces estandarizadas:

1. **Bloque B1 — Muestreo y CDAC Binario:**
   * Arreglo capacitivo binario de 8 bits ($1C_u \dots 128C_u$) + capacitor *dummy* de $1C_u$ ($C_u = 20\text{ fF}$, $C_{\text{total}} = 5,12\text{ pF}$) implementado con capacitores MIM `sky130_fd_pr__cap_mim_m3_1` ($\text{met3–met4}$).
   * Muestreo en plato inferior mediante compuertas de transmisión CMOS escaladas binariamente ($\tau_{\text{muestreo}} \approx 2,70\text{ ns} \le 5\text{ ns}$ incluyendo $R_{\text{pad}} = 500\ \Omega$).
   * Interruptor NMOS en plato superior con cancelación *dummy* para minimizar la inyección de carga ($\le 0,25\text{ LSB}$) y divisor resistivo integrado (`res_xhigh_po_0p69`) para generar $V_{cm} = 0,75\,V_{REF} = 0,9\text{ V}$.
2. **Bloque B2 — Comparador Dinámico StrongARM:**
   * Par de entrada NMOS dimensionado por Pelgrom ($W_{\text{eq}}/L = 25\ \mu\text{m}/1,0\ \mu\text{m}$) para mantener $\sigma_{\text{os}} \le 1\text{ mV}$.
   * Evaluación por flanco de bajada de `CLK_CMP` ($t_{\text{dec}} \le 10\text{ ns}$ con $\Delta V = 0,5\text{ LSB}$, energía $\approx 0,14\text{ pJ/decisión}$) y etapa de retención digital mediante *latch* SR (`sky130_fd_sc_hd__nand2_1`).
3. **Bloque B3 — Lógica SAR y Secuenciador Síncrono:**
   * Máquina de 10 estados a $10\text{ MHz}$ con celdas estándar `sky130_fd_sc_hd`: 1 ciclo de muestreo (`SAMPLE`), 8 ciclos de aproximación sucesiva (`S[7:0]`) y 1 ciclo de salida válida (`EOC`).

### Asignación de Pines (Tiny Tapeout)

| Señal | Pin Plantilla | Dirección | Nivel | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `VIN` | `ua[0]` | Entrada analógica | $0\text{–}1,2\text{ V}$ | Señal analógica a convertir ($R_{\text{pad}} < 500\ \Omega$, $C_{\text{pad}} < 5\text{ pF}$) |
| `VREF` | `ua[1]` | Entrada analógica | $1,2\text{ V}$ DC | Tensión de referencia externa |
| `clk` | `clk` | Entrada digital | $0 / 1,8\text{ V}$ | Reloj principal del sistema ($10\text{ MHz}$, $50\%$ duty cycle) |
| `rst_n` | `rst_n` | Entrada digital | $0 / 1,8\text{ V}$ | Reinicio maestro activo en bajo |
| `START` | `ui_in[0]` | Entrada digital | $0 / 1,8\text{ V}$ | Pulso de inicio de conversión |
| `D[7:0]` | `uo_out[7:0]` | Salida digital | $0 / 1,8\text{ V}$ | Palabra binaria de salida (válida cuando `EOC = 1`) |
| `EOC` | `uio[0]` | Salida digital | $0 / 1,8\text{ V}$ | Indicador de fin de conversión (*End of Conversion*) |
| `SAMPLE` / `CMP` | `uio[1]` / `uio[2]` | Salidas digitales | $0 / 1,8\text{ V}$ | Señales de diagnóstico de fase de muestreo y comparador |

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
│   ├── B1/               # Testbenches de caracterización AC, OP y asentamiento del CDAC
│   ├── B2/               # Testbenches de tiempo de decisión, energía y kickback
│   ├── B3/               # Testbench funcional y de temporización a 10 MHz
│   └── top/              # Testbenches de rampa (DNL/INL) y senoide coherente (FFT/ENOB)
├── simulations/
│   ├── run_pvt.spice     # Script maestro de barrido PVT y esquinas de proceso
│   └── pvt_results/      # Resultados numéricos y logs (ignorados en Git si son pesados)
├── xschemrc              # Configuración local de librerías SKY130A para Xschem
├── .magicrc              # Configuración tecnológica SKY130A para Magic
└── README.md             # Documentación principal del proyecto
```

---

## 4. Configuración del Entorno EDA

### Requisitos de Software
* **PDK:** `sky130A` gestionado vía `volare` (hash habilitado: `c6d73a35f524070e85faff4a6a9eef49553ebc2b`).
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
| **HV–hot** | $1,95\text{ V}$ ($+8,3\%$) | $85^\circ\text{C}$ | `tt`, `ff`, `sf`, `fs` |
| **HV–cold** | $1,95\text{ V}$ ($+8,3\%$) | $-40^\circ\text{C}$ | `tt`, `ff` |
| **LV–hot** | $1,62\text{ V}$ ($-10\%$) | $85^\circ\text{C}$ | `tt`, `ss`, `sf`, `fs` |
| **LV–cold** | $1,62\text{ V}$ ($-10\%$) | $-40^\circ\text{C}$ | `tt`, `ss` |

Para ejecutar el barrido automatizado de esquinas en `ngspice`:

```bash
cd simulations
for corner in tt ss ff sf fs; do
  sed "s/\.lib .* sky130\.lib\.spice .*/.lib \$PDK_ROOT\/\$PDK\/libs.tech\/ngspice\/sky130.lib.spice $corner/" run_pvt.spice > run_${corner}.spice
  ngspice -b run_${corner}.spice -o pvt_results/log_${corner}.log
done
```
