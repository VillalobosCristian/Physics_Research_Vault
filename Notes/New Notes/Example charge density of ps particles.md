# Cálculo de la carga de una partícula

Para calcular cuánta carga lleva **cada partícula** (suponiendo que todos los grupos COOH estén desprotonados y por tanto cargados negativamente), se procede así:

## 1. Calcular la masa de cada partícula
- El diámetro es \(1.65\,\mu\text{m}\), por lo que el radio es:
  $$
  r = 0.825\,\mu\text{m}.
  $$
- El volumen de una esfera está dado por:
  $$
  V = \frac{4}{3}\pi r^3.
  $$
  Con \(r = 0.825 \times 10^{-4}\,\text{cm}\) (pasando de \(\mu\text{m}\) a \(\text{cm}\)), el volumen queda expresado en \(\text{cm}^3\).

- Asumiendo una densidad aproximada del poliestireno de \(\rho \approx 1.05\,\text{g/cm}^3\), la masa de una partícula es:
  $$
  m_{\text{part}} = V \times \rho.
  $$

## 2. Convertir la densidad de grupos COOH a "grupos por gramo"
- La densidad de grupos COOH es \(100\,\mu\text{mol/g}\):
  $$
  100\,\mu\text{mol/g} = 100 \times 10^{-6}\,\text{mol/g} = 1 \times 10^{-4}\,\text{mol/g}.
  $$
- Usando el número de Avogadro (\(N_A = 6.022 \times 10^{23}\)), se tiene:
  $$
  1 \times 10^{-4}\,\text{mol/g} \times 6.022 \times 10^{23}\,\frac{\text{grupos}}{\text{mol}} = 6.022 \times 10^{19}\,\frac{\text{grupos COOH}}{\text{g}}.
  $$

## 3. Calcular cuántas partículas hay en 1 g
- Si la masa de una partícula es \(m_{\text{part}}\), el número de partículas por gramo es:
  $$
  \frac{1\,\text{g}}{m_{\text{part}}}.
  $$

## 4. Grupos COOH por partícula
- Dividiendo "grupos COOH por gramo" entre "partículas por gramo", se obtienen los grupos por partícula:
  $$
  \text{(Grupos COOH por partícula)} = \frac{6.022 \times 10^{19}\,\text{grupos COOH/g}}{\bigl(1\,\text{g}/m_{\text{part}}\bigr)}.
  $$

## 5. Carga por partícula
- Suponiendo ionización completa (cada grupo COOH aporta una carga negativa), el número de cargas por partícula es igual al número de grupos COOH por partícula.

- Para expresar la carga en coulombs, multiplicamos por la carga elemental \(e = 1.602 \times 10^{-19}\,\text{C}\):
  $$
  Q_{\text{part}} = \bigl(\text{grupos COOH por partícula}\bigr) \times 1.602 \times 10^{-19}\,\text{C}.
  $$

## Ejemplo numérico (valores aproximados)
- Volumen de una partícula:
  $$
  V \approx 2.35 \times 10^{-12}\,\text{cm}^3.
  $$
- Masa de una partícula:
  $$
  m_{\text{part}} \approx 2.46 \times 10^{-12}\,\text{g}.
  $$
- Número de partículas en \(1\,\text{g}\):
  $$
  \frac{1}{m_{\text{part}}} \approx 4.07 \times 10^{11}.
  $$
- Grupos COOH en \(1\,\text{g}\):
  $$
  6.022 \times 10^{19}.
  $$
- Grupos COOH por partícula:
  $$
  \frac{6.022 \times 10^{19}}{4.07 \times 10^{11}} \approx 1.48 \times 10^{8}.
  $$
- Carga por partícula:
  $$
  Q_{\text{part}} = 1.48 \times 10^{8} \times 1.602 \times 10^{-19}\,\text{C} \approx 2.37 \times 10^{-11}\,\text{C}.
  $$

En otras palabras, **cada partícula** lleva del orden de \(10^8\) grupos COOH y, si se ionizan todos, una carga neta de unas decenas de picoculombios por partícula. 

Si además necesitas la **carga total** en un volumen determinado de suspensión, tendrías que multiplicar la carga por partícula por el número total de partículas presentes (teniendo en cuenta también el contenido sólido del \(10\%\), si aplica).
