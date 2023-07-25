#Mathtools.psm1
function Get-addition {
  <#
  .SYNOPSIS
    This command adds 2
  .DESCRIPTION
    This command takes two inputs
  .NOTES
    Created by: mike g
    changelog:
    date    version   what was changed
    ---     -------   --------------
    24/jul/2023 1.0.0 script created
    24/jul/2023 1.0.5 add new version
    24/jul/2023 1.1.0 add div

  .EXAMPLE
    get-addition 
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
  .PARAMETER Num1
      This is the first number
  .PARAMETER Num2
      This is the Second number
  #>
  
  
  [cmdletbinding()]
  Param (
    $Num1,
    $Num2
  )
  $addhash = [ordered] @{
    Num1 = $Num1
    Num2 = $Num2
    Result = $Num1 + $num2
  }
  $resultobj = new-object -typename psobject -Property $addhash
  return $ResultObj
}

function Get-Multiplication {
  <#
  .SYNOPSIS
    This command mults 2
  .DESCRIPTION
    This command takes two inputs
  .NOTES
    Created by: mike g
    changelog:
    date    version   what was changed
    ---     -------   --------------
    24/jul/2023 1.0.0 script created
    24/jul/2023 1.0.5 add new version
    24/jul/2023 1.1.0 add div

  .EXAMPLE
    get-multiplication 
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
  .PARAMETER Num1
      This is the first number
  .PARAMETER Num2
      This is the Second number
  #>
  
  
  [cmdletbinding()]
  Param (
    $Num1,
    $Num2
  )
  $multhash = [ordered] @{
    Num1 = $Num1
    Num2 = $Num2
    Result = $Num1 + $num2
  }
  $ResultObj = new-object -typename psobject -Property $multhash
  return $ResultObj
}

function Get-division {
  <#
    .SYNOPSIS
    This command divides 2
  .DESCRIPTION
    This command takes two inputs
  .NOTES
    Created by: mike g
    changelog:
    date    version   what was changed
    ---     -------   --------------
    24/jul/2023 1.0.0 script created
    24/jul/2023 1.0.5 add new version
    24/jul/2023 1.1.0 add div

  .EXAMPLE
    get-division
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
  .PARAMETER Num1
      This is the first number
  .PARAMETER Num2
      This is the Second number
  #>
  
  
  [cmdletbinding()]
  Param (
    $Num1,
    $Num2
  )
  $divhash = [ordered] @{
    Num1 = $Num1
    Num2 = $Num2
    Result = $Num1 / $num2
  }
  $resultobj = new-object -typename psobject -Property $divhash
  return $ResultObj
}

# TO IMPORT RUN THE FOLLOWING SCRIPT
# import-module C:\scripts\mathtools.psm1
# get-addition -num1 321 -num2 54
# get-multiplication -num1 321 -num2 54

#if module was updated you need to remove the module using remove-module NAME and then import again

# SCRIPT TO SAVE VERSION (Donte forget to copy/paste version folder in path)
  #cd 'C:\Program Files\WindowsPowerShell\Modules\MathTools\1.1.0'
  #New-ModuleManifest -path .\MathTools.psd1 -moduleversion '1.1.0' -RootModule .\MathTools.psm1 -Author 'Mike Gogue' -Description 'give division' -FunctionsToExport get-addition, get-multiplication, get-division

  #get-module -ListAvailable  
  #Get-Content