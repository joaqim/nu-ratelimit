export module ratelimit {
    # Create a mutable list to hold queue history
    export-env { $env.QUEUE_LIST = [ ] }
    export use sleep_as_needed.nu *
}