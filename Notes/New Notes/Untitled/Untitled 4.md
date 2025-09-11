# Guía Completa: Simulación de Membranas Cooke con LAMMPS en macOS

## Requisitos Previos

- macOS (probado en macOS con Apple Silicon)
- Homebrew instalado
- Terminal con zsh
- Conexión a internet

## Paso 1: Instalación de Herramientas Básicas

```bash
# Instalar Homebrew (si no está instalado)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Instalar herramientas de desarrollo
brew install git cmake gcc python@3.11

# Instalar paquetes científicos
brew install openmpi fftw
```

## Paso 2: Clonar el Repositorio

```bash
# Clonar el repositorio de tutoriales
git clone https://github.com/Saric-Group/MembraneReviewTutorials.git
cd MembraneReviewTutorials

# Verificar contenido
ls -la
```

## Paso 3: Configurar Entorno Virtual de Python

```bash
# Crear entorno virtual
python3 -m venv membrane_env

# Activar entorno virtual
source membrane_env/bin/activate

# Actualizar pip e instalar paquetes necesarios
pip install --upgrade pip
pip install numpy matplotlib scipy pandas
pip install jupyter notebook ipython
pip install h5py tqdm
```

## Paso 4: Compilar LAMMPS con Paquetes Necesarios

```bash
# Navegar al directorio de LAMMPS
cd lammps

# Crear directorio de compilación
mkdir build
cd build

# Configurar LAMMPS con todos los paquetes necesarios
cmake ../cmake \
  -DPKG_MOLECULE=yes \
  -DPKG_RIGID=yes \
  -DPKG_EXTRA-MOLECULE=yes \
  -DPKG_EXTRA-PAIR=yes \
  -DPKG_MC=yes \
  -DPKG_USER-MISC=yes \
  -DBUILD_MPI=yes

# Compilar LAMMPS (esto toma varios minutos)
make -j4

# Verificar que se compiló correctamente
./lmp -help | grep "cosine/squared"
```

## Paso 5: Configurar PATH para LAMMPS

```bash
# Añadir LAMMPS al PATH (temporal)
export PATH=$(pwd):$PATH

# Verificar que funciona
lmp -help | head -10
```

## Paso 6: Preparar Simulación Cooke

```bash
# Regresar al directorio de simulaciones Cooke
cd ../../CookeSimulations

# Verificar archivos disponibles
ls -la

# Hacer respaldo del archivo de entrada original
cp in.lmp in.lmp.backup
```

## Paso 7: Modificar Archivo de Entrada para Compatibilidad

```bash
# Cambiar formato de salida de netcdf a formato estándar
sed -i '' 's/dump dump all netcdf 1000 traj.nc x y z/dump dump all custom 1000 traj.lammpstrj id type x y z/' in.lmp

# Eliminar línea problemática de dump_modify
sed -i '' '/dump_modify dump thermo yes/d' in.lmp

# Verificar cambios
grep "dump dump" in.lmp
```

## Paso 8: Ejecutar Simulación

```bash
# Simulación corta para prueba (2-3 minutos)
lmp -var seed 1 -var halfL 15 -var duration 2000. -in in.lmp

# O simulación mediana (15 minutos aprox)
lmp -var seed 1 -var halfL 20 -var duration 10000. -in in.lmp

# O simulación completa del paper (varias horas)
lmp -var seed 1 -var halfL 30 -var duration 60000. -in in.lmp
```

## Paso 9: Monitorear Progreso (en terminal separada)

```bash
# En una nueva ventana de terminal
cd MembraneReviewTutorials/CookeSimulations

# Seguir el archivo de log en tiempo real
tail -f log.lammps
```

## Paso 10: Crear Script de Visualización

```bash
# Crear script de visualización robusto
cat > simple_viz.py << 'EOF'
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

def read_trajectory_simple():
    """Simple, robust trajectory reader"""
    try:
        with open('traj.lammpstrj', 'r') as f:
            lines = f.readlines()
    except:
        print("Could not read trajectory file")
        return None
    
    print(f"Trajectory file has {len(lines)} lines")
    
    # Find the last TIMESTEP
    timesteps = []
    for i, line in enumerate(lines):
        if 'ITEM: TIMESTEP' in line:
            timesteps.append(i)
    
    if not timesteps:
        print("No timesteps found")
        return None
    
    print(f"Found {len(timesteps)} timesteps")
    
    # Read from the last timestep
    start_idx = timesteps[-1]
    
    # Find the number of atoms
    natoms = None
    for i in range(start_idx, min(start_idx + 10, len(lines))):
        if 'ITEM: NUMBER OF ATOMS' in lines[i]:
            natoms = int(lines[i+1].strip())
            break
    
    if natoms is None:
        print("Could not find number of atoms")
        return None
    
    print(f"Number of atoms: {natoms}")
    
    # Find atoms section
    atoms_start = None
    for i in range(start_idx, min(start_idx + 20, len(lines))):
        if 'ITEM: ATOMS' in lines[i]:
            atoms_start = i + 1
            break
    
    if atoms_start is None:
        print("Could not find atoms section")
        return None
    
    # Read atom data
    atoms = []
    for i in range(atoms_start, min(atoms_start + natoms, len(lines))):
        parts = lines[i].strip().split()
        if len(parts) >= 5:
            try:
                atom_id = int(parts[0])
                atom_type = int(parts[1])
                x = float(parts[2])
                y = float(parts[3])
                z = float(parts[4])
                atoms.append([atom_id, atom_type, x, y, z])
            except:
                continue
    
    if not atoms:
        print("No atoms read successfully")
        return None
    
    return np.array(atoms)

# Read the trajectory
print("Reading trajectory...")
atoms = read_trajectory_simple()

if atoms is not None:
    print(f"Successfully read {len(atoms)} atoms")
    
    # Separate head and tail beads
    heads = atoms[atoms[:, 1] == 1]  # type 1 = heads
    tails = atoms[atoms[:, 1] == 2]  # type 2 = tails
    
    print(f"Head beads: {len(heads)}")
    print(f"Tail beads: {len(tails)}")
    
    # Create visualization
    fig = plt.figure(figsize=(15, 5))
    
    # 3D view
    ax1 = fig.add_subplot(131, projection='3d')
    ax1.scatter(heads[:, 2], heads[:, 3], heads[:, 4], c='red', s=20, alpha=0.8, label='Heads')
    ax1.scatter(tails[:, 2], tails[:, 3], tails[:, 4], c='blue', s=10, alpha=0.6, label='Tails')
    ax1.set_xlabel('X')
    ax1.set_ylabel('Y')
    ax1.set_zlabel('Z')
    ax1.set_title('3D Membrane')
    ax1.legend()
    
    # Side view (showing bilayer)
    ax2 = fig.add_subplot(132)
    ax2.scatter(heads[:, 2], heads[:, 4], c='red', s=15, alpha=0.8, label='Heads')
    ax2.scatter(tails[:, 2], tails[:, 4], c='blue', s=8, alpha=0.6, label='Tails')
    ax2.set_xlabel('X')
    ax2.set_ylabel('Z')
    ax2.set_title('Side View (Bilayer)')
    ax2.legend()
    
    # Z distribution
    ax3 = fig.add_subplot(133)
    ax3.hist(heads[:, 4], bins=30, alpha=0.7, color='red', label='Heads')
    ax3.hist(tails[:, 4], bins=30, alpha=0.7, color='blue', label='Tails')
    ax3.set_xlabel('Z position')
    ax3.set_ylabel('Count')
    ax3.set_title('Height Distribution')
    ax3.legend()
    
    plt.tight_layout()
    plt.savefig('membrane_final.png', dpi=150, bbox_inches='tight')
    plt.show()
    
    print("Visualization saved as 'membrane_final.png'")
    
    # Print some statistics
    print(f"\nMembrane Statistics:")
    print(f"Head Z range: {heads[:, 4].min():.2f} to {heads[:, 4].max():.2f}")
    print(f"Tail Z range: {tails[:, 4].min():.2f} to {tails[:, 4].max():.2f}")
    print(f"Membrane thickness: {heads[:, 4].max() - heads[:, 4].min():.2f}")
else:
    print("Could not visualize - no trajectory data")
EOF
```

## Paso 11: Visualizar Resultados

```bash
# Una vez que la simulación termina, ejecutar visualización
python simple_viz.py

# Abrir imagen generada (en macOS)
open membrane_final.png

# Verificar archivos generados
ls -la *.lammpstrj *.lammps *.png
```

## Paso 12: Análisis Adicional

```bash
# Ver estadísticas finales de la simulación
tail -20 log.lammps

# Contar frames en la trayectoria
grep -c "TIMESTEP" traj.lammpstrj

# Ejecutar análisis original del tutorial (si funciona)
python analyze.py .
```

## Resultados Esperados

Al completar todos los pasos, deberías tener:

1. **Simulación exitosa**: LAMMPS ejecutándose sin errores
2. **Archivo de trayectoria**: `traj.lammpstrj` con datos de posiciones
3. **Archivo de log**: `log.lammps` con energías y estadísticas
4. **Visualización**: `membrane_final.png` mostrando:
    - Vista 3D de la membrana
    - Vista lateral mostrando estructura bicapa
    - Distribución de alturas de cabezas (rojas) y colas (azules)

## Solución de Problemas Comunes

### Error: "cosine/squared not found"

```bash
# Recompilar LAMMPS con EXTRA-PAIR package
cd lammps/build
cmake ../cmake -DPKG_EXTRA-PAIR=yes
make -j4
```

### Error: "netcdf not found"

```bash
# Ya solucionado en el Paso 7 cambiando a formato custom
```

### Error de visualización

```bash
# Verificar que el entorno virtual está activo
source membrane_env/bin/activate

# Instalar paquetes faltantes
pip install matplotlib numpy
```

## Parámetros de Simulación

|Parámetro|Valor|Descripción|
|---|---|---|
|`halfL`|15, 20, 30|Medio tamaño de caja (caja total = 2×halfL)|
|`duration`|2000, 10000, 60000|Número de pasos de simulación|
|`seed`|1|Semilla para números aleatorios|

## Tiempos Estimados

- **Simulación corta** (halfL=15, duration=2000): 2-3 minutos
- **Simulación mediana** (halfL=20, duration=10000): 15 minutos
- **Simulación completa** (halfL=30, duration=60000): 2-8 horas

## Notas Importantes

1. **Entorno virtual**: Siempre activar antes de trabajar
2. **PATH de LAMMPS**: Configurar en cada sesión nueva
3. **Archivos de respaldo**: Mantener `.backup` de archivos modificados
4. **Monitoreo**: Usar `tail -f log.lammps` para seguir progreso

¡Con esta guía deberías poder reproducir toda la simulación desde cero!