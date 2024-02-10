# https://github.com/nushell/nu_scripts/blob/main/modules/weather/timed_weather_run_env.nu

# Create a mutable list to hold queue history
#export-env { $env.$env._RATELIMIT_QUEUE_LIST = [ ] }

export def --env enqueue [item: any] -> list {
    $env._RATELIMIT_QUEUE_LIST = ($env._RATELIMIT_QUEUE_LIST | append $item)
}

export def --env dequeue [] -> any {
    let item = ($env._RATELIMIT_QUEUE_LIST | get 0)
    $env._RATELIMIT_QUEUE_LIST = ($env._RATELIMIT_QUEUE_LIST | skip 1)
    ($item)
}

export def --env size [] -> int {
    ($env._RATELIMIT_QUEUE_LIST | length)
}

export def --env reset [] {
    $env._RATELIMIT_QUEUE_LIST = []
}

export def --env queue_list [] {
    $env._RATELIMIT_QUEUE_LIST
}
