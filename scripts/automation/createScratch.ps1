$userstory =  $args[0]
$description =  $args[1]
$dias = $args[2] ? $args[2]: 7
$definitionFile = '.\config\project-scratch-def.json'
$email =  $userstory + '@teco.com.ar'

if ( $args[0] -AND $args[1] ) {
    #    sf org list --clean --no-prompt
    sf org create scratch -y $dias --description $description --name $userstory  -a $userstory -d -w 10 --username $email --definition-file $definitionFile
    sf org generate password --target-org $userstory
    sf project deploy start --target-org $userstory
    sf org assign permset --name dreamhouse --target-org $userstory
    sf data import tree --plan .\data\sample-data-plan.json -u $userstory
    sf apex run --target-org $userstory -f .\scripts\apex\debugMode.apex
    sfdx org display user
} else {
    write-host("createScratch story-id story-subject days.
    ejemplo createScratch BSCCC22 'Cambiar Funcionalidad' 30")
}