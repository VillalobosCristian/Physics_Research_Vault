---
tags:
  - "#statistical-mechanics"
  - "#thermal-distributions"
  - "#quantum-mechanics"
  - "#microstates"
  - "#thermodynamic-equilibrium"
  - "#quantum-statistics"
---
# Formulario

- $\colorbox{aquamarine}{Primeras preguntas}$
    
    - **¿Qué es un microestado?**
        
        Un microestado es un estado de un sistema de muchas partículas donde todas las variablers microscópicas de interes están especificadas. Por ejemplo: La posición, momentum, etc. Experimentalmente es complicado acceder a los microestados debido a la cantidad de partículas de un sistema.
        
    - **¿Qué es un macroestado?**
        
        Es el estado termodinámico del sistema, el estado que observamos experimentalmente y definido por variables macroscopicas.
        
    - **¿Qué cantidad es fundamental en los distintos ensambles?**
        
        En el ensamble microcanónico se mantiene la energía fíja, en este ensable es recalcable el calculo de entropía del sistema, siendo esta la variable utilizada para encontrar los parámetros termodinámicos.
        
        En el ensamble canónico, el sistema está en contacto con otro sistema a temperatura $T$ y en equilibrio térmico. El número de partículas es constante, y la energía libre de Helmholtz es la variable más importante a encontrar.
        
        En el ensamble grand canónico, el sistema está en contacto con otro con el cual puede intercambiar partículas, por lo que $N$ no es constante y se busca determinar el potencial químico.
        
        Qué es un ensamble
        
        Micro estado accesible
        
        Poner ecuaciones(las mencionó harto)
        
        Cuál conecta con la termodinámica
        
    - **¿Qué es la función de partición?**
        
        Es el peso estadístico de tener partículas con una cierta energía.
        
    - **¿Qué es el potencial Químico?**
        
        El potencial químico se puede entender como la energía media necesaria para agregar otra partícula al sistema.
        
    - **¿Cuál es el objetivo de la física estadística?**
        
        Determinar las propiedades termodinámicas de los sistemas macroscópicos a través de sus propiedades microscopicas. Siempre asumiremos que trabajamos con un número gigante de copias del sistema, cada una de ella en algún microestado del sistema. Las propiedades de macroscópicas de equilibrio serán entonces los promedios de sobre los microestados.
        
        - ¿Qué otros ensambles hay?
    - **¿Qué otros ensambles hay?**
        
        Colectividad isotermica-isobarica. se busca equilibrio mecánico.
        
        Cuál es la cantidad fundamental
        
    - **¿Cuál es el postulado fundamental del Ensamble microcanónico?**
        
        El postulado de igualdad a priori. El cual establece que todos los microestados compatibles con un macroestado del sistema tienen igual probabilidad. Para la mecánica cuántica es el postulado de igual probabilidad a priori.
        
    - **¿Cuál es la probabilidad de un determinado microestado?**
        
        $P_r = \frac{1}{\Omega}$
        
    - **¿Cómo son los microestados de dos sistemas en equilibrio entre sí y aislados del resto del universo?**
        
        El número de microestados para dos sistemas será máximo si están aislados e igual a $\Omega(E_1,V_1,N_1,E_2,V_2,N_2)$.
        
        Sumar o multiplicar
        
    - **¿Cómo es el número de microestados de un sistema compuesto, $1+2$?**
        
        Para este sistema comopuesto se cumple $E=E_1+E_2$, $V=V_1+V_2$, $N=N_1+N_2$. Por lo que el número de microestado es $\Omega(E,V,N,E_1,V_1,N_1)=\Omega_1 \Omega_2$, debido a que los sistemas son independientes(por eso es la multiplicación)
        
    - **Para dos sistemas que se juntan, el equilibrio se alcanza cuando $\Omega$ es máximo.**
        
    - **¿Cuál es la condición de máximo?**
        
        $\frac{d\Omega}{dE_1}=0$, es decir, $\frac{1}{\Omega_1}(\frac{\partial \Omega_1}{\partial E_1})=\frac{1}{\Omega_2}(\frac{\partial \Omega_2}{\partial E_2})$
        
    - **¿Cómo evolucionan los sistemas?**
        
        Un sistema aislado evoluciona maximizando su entropía según la termodinámica y maximizando su número de microestados segun la física estadística.
        
    - **¿Cuáles son condiciones de equilibrio termodinámico?**
        
        $T_1=T_2$, $p_1=p_2$, $\mu_1=\mu_2$, se expresan mediante derivadas e igualadades de $S$ respecto a sus variables naturales
        
    - **¿La entropía es extensiva?**
        
        Sí, la entropía es extensiva $S=S_1+S_2$ de aquí deriva que $\Omega \propto E^{N\phi}$
        
        Por qué se puede sumar las propiedades extensivas
        
    - **¿Qué es la entropía?**
        
        Desde la termodinámica se interpreta como una medida de desorden de un sistema. En concreto, de la falta de disponibilidad en el sistema de energía convertible en trabajo.
        
        Poner o interpretar ecuación
        
    - **Cuándo la entropía es cero?**
        
        La entropía es cero cuando el numéro de microestados es 1, es decir, el estado es totalmente predecible.
        
    - **¿Qué es la paradoxa de Gibbs y cómo se corrige?**
        
    - **¿Qué variable se define para distinguir entra la estadística clásica y la estadística cuántica?**
        
        La longitud de onda de De Broglie $\lambda =(\frac{h^2}{2\pi m k_bT})^{1/2}$ y la longitud de coherencia cuántica de las partículas que componen al sistema $l = (\frac{V}{N})^{1/3}$. A partir de estas dos longitudes podemos definir $\lambda/l \lll 1$ que nos conduce a $\lambda^3 n = (\frac{h^2}{2\pi m k_B T})^{3/2}$ con $n\lll 1$. Si esta condición no se cumple, se estudia el sistema en la estadísitica cuántica
        
    - $\colorbox{lightblue}{Clasificación de los sistemas estadísticos}$
        
        - Sistemas estadísticos Cuánticos-Discretos. Estos sistemas se caracterizan por tener niveles de energía discreto, pero se debe tomar en cuenta la simetría de la función de onda para ver si las partículas son bosones o fermiones y tratarlas con la estadística correspondiente.
        - Sistemas estadísticos cuánticos-continuos Se toma en cuenta la simetría de la función de onda, pero los niveles de energía están tan cercanos que se consideran continuos. Ej: Gas ideal cuántico
        - Sistemas estadísiticos clásicos-discretos. Cuando las partículas están muy separadas entre si se desprecian los efectos de la coherencia cuántica de las partículas y se utiliza estadística clásica para tratarlas.
        - Sistemas estadísticos Clásico-Continuos. El espectro de energía se considera continuo, por ejemplo, partículas libres, altas temperaturas en sólidos. Para estos últimos dos casos se utiliza la estadística de Maxwell-Boltzman.
        
        ![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/f7b46a7a-3b1c-488c-bdb1-5799c3c7f7f8/Untitled.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/f7b46a7a-3b1c-488c-bdb1-5799c3c7f7f8/Untitled.png)
        
    - **Teorema de equipartición de la energía**
        
        El teorema de equipartición relaciona la energía cinética de las partículas de un sistema con su temperatura. $E=\langle H \rangle = N' \frac{k_B T}{\eta}$, donde $N'$ son los grados de libertad y $\eta$ la potencia del hamiltoniano.
        
        - $\textbf{Partículas libres}$:tienen un hamiltoniano $H= \sum p_i^2/2m$, tenemos $3N$ momentos y $\eta = 2$, luego $E=\frac{3}{2}k_B T$.
        - $\textbf{Oscilador armónico}$: $E = \frac{3}{2}k_B T + \frac{3}{2}k_B T = 3Nk_B T$.
    - $\colorbox{lavender}{Ensamble Macrocanónico- Grand canónico}$
        
        Este Ensamble ayuda a describir los sistemas donde $N$ no es constante, o la exigencia de que $N$ sea fijo hace que la suma en el ensamble canónico sea difícil de realizar, como en los sistemas cuánticos. Acá $E$ y $N$ son variables del sistema y se define como variable termodinámica de conección el potencial químico $\mu$. El sistema está en equilibrio químico y térmico con un resorvorio de partículas cuyo potencial químico es $\mu$. Por lo tanto el sistema está descrito por $\mu$, $V$, $T$.
        
        $\textbf{Fugacidad}$: Se define la fugacidad $z$ como $z = e^{\beta \mu}$, est
        
    - $\colorbox{lightgreen}{Mecánica estadística Cuántica}$
        
        Cuando las funciones de onda se comienzan a solapar, la coherencia cuántica debe tomarse en cuenta desde el comienzo del planteo del problema. También se pueden estudiar usando la estadística clásica algunos problemas tomando en consideración la cuantización de la energía. A pesar de ser efectos microscopicos, la coherencia cuántica tiene efectos incluso a temperatura ambiente (radiación de cuerpo negro, gas de electrones, etc).
        
        - $\textbf{Matriz de densidad}$: La matriz de densidad $\hat{\rho}$ es un operador autoadjunto, que se puede interpretar como la densidad de probabilidad en términos de la estadísitica. Debido a que es dificil conocer la función de onda de un sistema de $N$ partículas, se puede calcular su valor medio mediante $\langle \hat{A} \rangle = \sum_i \langle \phi_i |\hat{A}\hat{\rho}|\phi_i \rangle = Tr({\hat{A}\hat{\rho}})$. Para estados estacionarios la matriz de densidad es diagonal en la base donde el Hamiltoniano es diagonal, ya que al no ser una variable dinámica se cumple que $\hat{\rho}=f(\hat{H})$, $[\hat{H},\hat{\rho}]=0$
        - $\textbf{Colectividad microcanónica}$: Además del postulado de igual probabilidad a priori, se debe agregar otro postulado que asegure que los elementos no diagonales de la matriz de densidad se anulen. Esto es que las fases aleatorias tengan igual probabilidad. en cualquier base.
        - $\textbf{Colectividad canónica}$: En este caso la matriz de densidad en la representación diagonal de energía viene dada por $\hat{\rho}= \frac{1}{Z}\sum_i e^{-\beta E_i}$. Y la función de partición viene descrita por $Z = Tr(e^{-\beta\hat{H}})$.
        - $\textbf{Colectividad macrocanónica}$: En este ensamble el hamiltoniano conmuta con el operador numero de partículas $\hat{N}$.
        
        Se define que $N$ partículas son indistinguibles si cuando no existe un observable que las distinga. Para todas las posibles configuraciones $N!$ de funciones de onda, la densidad de probabilidad queda definida por la paridad de la función de onda.
        
        - $\textbf{Teorema de la conexión Spin-Estadísitca}$: Este teorema nos dice cuándo la función de onda será simétrica o anti simétrica. Postula que si las partículas tienen spin entero, serán bosones y si tienen spin semi entero serán fermiones. Se utiliza la estadísitica respectiva para cada tipo de partículas. Donde los fermiones no pueden ocupar un mismo lugar energético debido al principio de exclusión de Pauli.
        
        $\textbf{Notación unificada para las tres estadísiticas}$:
        
        Podemos escribir las tres estadísticas utilizando el valor $a$ el cual toma valores $0,1,-1$ para la estadística de Maxwell-Boltzmann, Fermi-Dirac y Bose-Einstein respectivamente.
        
        $q = \ln{\mathscr{Q}}= \frac{1}{a}\sum_j{(1+az e^{-\beta \epsilon_j})}$. La estadística de M-B se obtiene tomando el límite de $q$.
        
    - **Paramagnetismo**
        
        Una sustancia es paramagnética si tiene imantación nula cuando no hay campo externo aplicado. Concentrandonos en el paramagnetismo de Langevin , las variables termodinámicas que describen el sistema son $M, T,H$, donde se busca la ecuación de estado la cual es la ley de Curie. En el caso cuántico se considera la cuantización de $E$ debido a que el momento magnético está cuantizado, pero al estar fijas las partículas se puede asumir sin perdida de generalidad que las funciones de onda no se solapan
        
    - **¿Qué es un cuerpo negro?**
        
        Un cuerpo negro consiste en una cavidad de volumen $V$ que contiene únicamente radiación electromagnética emitida y absorbida por las paredes de la cavidad, y que se encuentra en eq termodinámico a temperatura T.Por la cavidad se observa el flujo de radiación electromagnética.
        
- $\colorbox{aquamarine}{Segundas preguntas}$
    
    - **¿Qué es la energía de Fermi?**
        
        La energía de Fermi es un valor límite del potencial químico a $T=0$. Donde todos los espacios de energía $\epsilon<\epsilon_f$ están ocupados.
        
    - **¿Cómo es la distrribución binomial?**
        
        $\binom{p}{q} = \frac{p!}{q!(p-q)!}$, es el número de formas de elergír un subset no ordenado de tamaño $q$ desde un set de tamaño $p$.
        
    - **¿Qué es una cantidad extensiva?**
        
        Una cantidad que escala linealmente con el tamaño del sistema.
        
    - **¿Qué es una cantidad intesiva?**
        
        Cantidades que se mantienen constantes cuando el sistema crece. $T$, $\mu$, $P$.
        
    - **¿La entropía es un máximo o un extremo?**
        
        La entropía al estar definida como un logaritmo, es un máximo en vez de un extremo.
        
- ## $\colorbox{thistle}{Repaso}$