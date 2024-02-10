export-env { 
    $env._RATELIMIT_QUEUE_LIST = [ ] 
    $env.SLEEP_LOG = [ ] 
}
export use ./test_queue.nu
export use ./test_ratelimit.nu