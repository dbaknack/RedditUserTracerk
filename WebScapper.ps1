function Get-UDFsubredditsubscribers{
    param (
        [string[]]$subReddit
    )
    begin{
        #check to see if we are already tracking this subreddit
        if(Test-Path .\subredditsTracker){
            $ifSubredditsExist = $true
        }else{
            $ifSubredditsExist = $false
            Write-Verbose -Message "creating 'subredditsTracker...'" -Verbose
            New-Item -Path .\ -Name 'subredditsTracker'
        }
    }
    process{
        foreach($sub in $subReddit){
            $aboutPage  = "https://www.reddit.com/r/{0}/about.json" -f $sub
            $pageData   = ((Invoke-WebRequest -Uri $aboutPage).content | ConvertFrom-Json).data
            $objectHash = [PSCustomObject]@{
                subname     = $pageData.display_name
                activeusers = $pageData.active_user_count
                subscribers = $pageData.subscribers
                datetime    = (get-date).ToString("yyyy-MM-dd HH:mm:ss")
            }
        }

        if($ifSubredditsExist){
            foreach ($line in $objectHash){
                add-content -value $line  -Path .\subredditsTracker
            }
        }
    }
}

Get-UDFsubredditsubscribers -subReddit 'nucypher','keepNetwork','wallstreetbets'


