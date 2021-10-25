function Get-Subs {
    param (
        [string[]]$subReddit
    )
    begin{

    }
    process{
        foreach($sub in $subReddit){
                $subname = $sub
                $date = (get-date).ToString("yyyy-MM-dd HH:mm:ss")
                $redditAddress1 = "https://www.reddit.com/r/{0}/about.json"
                $redditAddress2 = $redditAddress1 -f $sub
                $completedsersults = Invoke-WebRequest -Uri $redditAddress2
               $total =  (($completedsersults | ConvertFrom-Json).data).subscribers
               write-host "$subname, $total, $date"
            }
        }
    end{

    }
}
$date = get-date

cls;(get-subs -subReddit 'nucypher','KeepNetwork','thresholdnetwork')
