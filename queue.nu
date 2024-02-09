# https://github.com/nushell/nu_scripts/blob/main/modules/weather/timed_weather_run_env.nu

# Create a mutable list to hold queue history
#export-env { $env.QUEUE_LIST = [ ] }

export def --env enqueue [item: any] -> list {
    $env.QUEUE_LIST = ($env.QUEUE_LIST | append $item)
}

export def --env dequeue [] -> any {
    let item = ($env.QUEUE_LIST | get 0)
    $env.QUEUE_LIST = ($env.QUEUE_LIST | skip 1)
    ($item)
}

export def --env size [] -> int {
    ($env.QUEUE_LIST | length)
}

export def --env reset [] {
    $env.QUEUE_LIST = []
}

export def --env queue_list [] {
    $env.QUEUE_LIST
}
