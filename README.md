# Value List
This is a Rails application, initially generated using [Potassium](https://github.com/platanus/potassium) by Platanus.

## Versions

### Release - 1.12.0
- Vista Otros
- y mejoras varias en performance, fixes, etc

### Release - 1.11.0
- Vista Resumen
- y mejoras varias en performance, fixes, etc

### Release - 1.9.0
- Configuración del Vendor Theme en el backend
- Pasivos
- Nuevo endpoints de accounts con sub-accounts e instrumentos (Opcionales)
- Mejoras y correcciones en el exportador en PDF y Excel
- Endpoints Supervisores
- Mejoras en el Super Admin
- Login por Vendor
- Back de "Otras inversiones"

### Release - 1.8.1
- Se agrega el tipo de instrumento: Money Market
- Se cambia el la forma de obtener la moneda para los calculos
- Se incrementa el client_max_body_size de nginx a 50M para poder subir archivos mas grandes

### Release - 1.8.0
- Flujo para recordar contraseña (V2)
- Endpoints para la vista de Supervisor
- Endpoints para la vista de Asesor
- Nuevos endpoints para la vista de Inversionista (V2)
- Se agrega el nombre del ambiente al Subject en el envio de correos
- Se cambia la forma de calcular el "Peso Relativo" al exportar en Excel
- Corregir logica de usuarios Admin, Asesor y Supervisor
### HOTFIX - 1.7.6
- Conversion en cards vista mobile y suma
### HOTFIX - 1.7.5
- Nombres de tipos de activos 
### WIP 1.7.4
- Creación de nuevos perfiles, logins, actualizacion de contraseñas y endpoints para V2
### HOTFIX - 1.7.3
- Infotabs de real estate en vista mobile
### HOTFIX - 1.7.2
- Calculos en tabla totales y cambios de monedas correctos y plusvalia
### HOTFIX - 1.7.1
- Ordenados desempeño instrumento
### Release 1.7.0
- Bienes raices
- Moneda UF
- Mejoras graficas 
- Columna de checkbox
### HOTFIX - 1.6.1
- Responsive tablas.
### Release 1.6.0

- Mejoras en el pipeline de Bitbucker
- Endpoint para obtener AUM
- Se agrega nueva moneda Euros
- Nuevo diseño en tablas, ventanas emergentes y más
- https://bitbucket.org/valuelist/valuelist-ruby/branch/release/1.6.0

### Release 1.5.0
- Cálculo de tablas en versión mobile 
- Cambios en textos de tooltips y tablas
- Exportar resumen de inversiones en PDF (Frontend)
- Implementar piloto para obtener valor de propiedades
- Fondos de pensiones 

### HOTFIX - 1.4.2
- Version mobile hacia mal los calculos de monedas en las cuentas y portafolios, PARTE 2.
### HOTFIX - 1.4.1
- Version mobile hacia mal los calculos de monedas en las cuentas y portafolios.
### Release 1.4.0
- Cambio de nombres en las tablas de inversion, concentracion, desempeño inversiones.
- Arreglo de decimales al comprar o vender instrumentos.

### Release 1.3.0
- Exportar PDF
### Release 1.2.0
- Añadido el topbar version Desktop y Mobile.
### Release 1.1.0
- Nueva versión de datos demo
- Correción del boton "Volver a las relaciones" en vista de inversor

## Local installation

El ambiente de desarrollo local funciona con docker por lo que es necesario tener instalado docker y docker-compose

Para ejecutar un ambiente local pero usando la base de datos de desarrollo (RDS):

    $ docker-compose -f docker-compose-local.yml up

Para ejecutar un ambiente de desarrollo completamente local, con todos los servidores funcionando dentro de contenedores docker:

    $ docker-compose -f docker-compose-backend.yml up

