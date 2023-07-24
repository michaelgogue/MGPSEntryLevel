

function DisplayBoard {
    Param ($Board)
    Clear-Host

    write-host " $($Board[0]) | $($Board[1]) | $($Board[2]) "
    Write-host "---+---+---"
    write-host " $($Board[3]) | $($Board[4]) | $($Board[5]) "
    write-host "---+---+---"
    write-host " $($Board[6]) | $($Board[7]) | $($Board[8]) "
    Write-host
}

do {
    $CurrentPlayer = 'X','O' | Get-Random
[system.collections.arraylist]$TicTacToeBoard = @(1,2,3,4,5,6,7,8,9)
$GameOver = $False
$Draw = $False
    do {
        DisplayBoard -Board $TicTacToeBoard
        do  {   
            $Choice = Read-Host -prompt "Player $CurrentPlayer, please choose your spot"
            $GoodSpots = @(1,2,3,4,5,6,7,8,9)
            if ($TicTacToeBoard -contains $Choice -and $GoodSpots -contains $Choice) {$TryAgain = $false}
            else {$TryAgain = $True}
        } While ($TryAgain -eq $true)
            $TicTacToeBoard[$Choice -1] = $CurrentPlayer    
        
        $WinningLines = @(
            @(0,1,2), 
            @(3,4,5),
            @(6,7,8),
            @(0,3,6),
            @(1,4,7),
            @(2,5,8),
            @(0,4,8),
            @(2,4,6)
        )
        foreach ($winningline in $Winninglines) {
            $PositionValues = ($TicTacToeBoard[$WinningLine] | Select-object -Unique)
            if($PositionValues.count -eq 1) {
                $GameOver = $True
                break
            }    
        }
        if ($Gameover -eq $false -and ($TicTacToeBoard | Select-Object -Unique).count -eq 2) {
            $Draw = $true
            $GameOver = $true
        }
        if ($GameOver -eq $False) {
            if ($CurrentPlayer -eq 'X') {$CurrentPLayer = 'O'}
            else {$CurrentPlayer = 'X'}
        }
    } until  ($GameOver -eq $True)
    
    DisplayBoard -Board $TicTacToeBoard
    if ($Draw -eq $false) {Write-Host "$CurrentPlayer, you are the winner"}
    else {write-host "Nobody won this round"}
    $Again = read-host -prompt 'Do you want to play again (Yes/No)'
    if ($again -like 'y*') {$KeepPlaying =$true}
    else {$KeepPlaying = $False}
}  while ($KeepPlaying -eq $True)




# interactive game
#  1 | 2 | 3 
#  ---+---+---
#  4 | 5 | 6 
#  ---+---+---
#  7| 8 | 9 
#  ---+---+---
    # PRINT BOARD ON SCREEN
        # ASK FOR INPUT AND DECLARE WHO'S TURN "WHICH POSITION DO YOU WANT TO PLAY, SELECT NUMBER BETWEEN 1-9"

        # CHECK FOR WRONG RESPONSES - (NOT 1-9, OR ALREADY CHOSEN)
        # IF WRONG, ASK AGAIN

        # DECLARE WHO'S TURN3
    

        # CHANGE BOARD TO REFLECT CHOICE

        # CHECK GAME STATE (WIN, LOSE, DRAW)
        # WIN = 3 IN A ROW, COLUMN OR DIAGONAL

        # CHECK FOR PLAY AGAIN AND THEN RESET BOARD
