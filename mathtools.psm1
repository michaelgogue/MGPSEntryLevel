#Mathtools.psm1

function Get-addition {
  Param (
    $Num1,
    $Num2
  )
  return $num1 + $num2
}

function Get-Multiplication {
  Param (
    $Num1,
    $Num2
  )
  return $num1 * $num2
}


# TO IMPORT RUN THE FOLLOWING SCRIPT
# import-module C:\scripts\mathtools.psm1
# get-addition -num1 321 -num2 54
# get-multiplication -num1 321 -num2 54

#if module was updated you need to remove the module using remove-module NAME and then import again