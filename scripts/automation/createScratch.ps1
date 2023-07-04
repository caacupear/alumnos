$userstory =  $args[0]
$description =  $args[1]
$dias = $args[2] ? $args[2]: 7
$definitionFile = $args[3] ? '.\config\scratch-with-omni.json' : '.\config\project-scratch-def.json'
$email =  $userstory + '@teco.com.ar'

if ( $args[0] -AND $args[1] ) {
    #    sf org list --clean --no-prompt
    sf org create scratch -y $dias --description $description --name $userstory  -a $userstory -d -w 10 --username $email --definition-file $definitionFile
    sf org generate password --target-org $userstory
    sf project deploy start --target-org $userstory
    sf org assign permset --name dreamhouse --target-org $userstory
    sf data import tree --plan .\data\sample-data-plan.json -u $userstory
    sf apex run --target-org $userstory -f .\scripts\apex\debugMode.apex
    if ( $args[3] ) {
        write-host("Por favor active ContactsToMultipleAccounts desde Configuracion > Cuentas > Configuracion de Cuentas ")
        write-host("https://test.salesforce.com/lightning/setup/AccountSettings/home ")
        write-host("Modificar y seleccionar Permitir a los usuarios relacionar un contacto con cuentas múltiples y guardar!")
        write-host("Instalar Omnistudio puede tardar mucho tiempo, revise el email")
        echo y | sf package install --target-org $userstory --package 04t5c000000o7RXAAY
    }
    sfdx org display user
} else {
    write-host("createScratch story-id story-subject days isOmni.
    ejemplo createScratch BSCCC22 'Cambiar Funcionalidad' 30 Yes")
}