use ./queue.nu

# It returns a delayed result based on rate limiting logic
# Example usage:
# sleep_as_needed --requests-per-interval 240 --interval-seconds 60
export def --env main [--requests-per-interval = 240, --interval-seconds = 60] {
    # Check for invalid arguments
    if $requests_per_interval <= 0 {
        error make { 
            msg: $"Invalid value."
            label: { text: "Expected positive integer: ", span: (metadata $requests_per_interval).span },
        }
    }
    if $interval_seconds <= 0 {
        error make { 
            msg: $"Invalid value."
            label: { text: "Expected positive integer", span: (metadata $interval_seconds).span },
        }
    }

    # Initialize variables
    let $interval_ms = ($interval_seconds * 1000)
    let $now: int = (date now | format date "%s%.6f" | into int)
    queue enqueue $now

    # Check rate limit
    if (queue size) >= $requests_per_interval {
        let last: int = (queue dequeue)
        let difference_ms = ($now - $last)
        let delay_ms = ($interval_ms - $difference_ms)

        if $delay_ms > 0 {
            let delay = ($delay_ms | into duration --unit ms)
            queue reset
            # Allow interrupt to sleep without throwing error
            try {
                sleep $delay
            }
        }
    }
}
