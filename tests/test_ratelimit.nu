
use std assert

def --env sleep [duration: duration] { $env.SLEEP_LOG = ($env.SLEEP_LOG | append ($duration | into int)) }

use ../sleep_as_needed.nu
use ../queue.nu

use std assert

# Define a function to calculate modulo without using %
def modulo [dividend: int, divisor: int] {
  # Ensure divisor is positive
    if $divisor <= 0 {
        error make { 
            msg: $"Invalid value."
            label: { text: "Expected positive integer", span: (metadata $divisor).span },
        }
    }

  mut result = $dividend
  # Subtract divisor from dividend until it's less than divisor
  while $result >= $divisor {
    $result = ($result - $divisor)
  }
  $result
}

def --env run_delay_test [REQUESTS_PER_INTERVAL = 2, INTERVAL_SECONDS = 1, MOCK_REQUESTS_AMOUNT = 15] {
    # TODO: Calculating $expected_total_delay_ms only works when $MOCK_REQUESTS_AMOUNT % $REQUESTS_PER_INTERVAL == 0
    assert (( modulo $MOCK_REQUESTS_AMOUNT $REQUESTS_PER_INTERVAL) == 0)
    let start  = (date now)
    mut expected_total_delay_ms  = 0
    for x in 1..$MOCK_REQUESTS_AMOUNT {
        sleep_as_needed --requests-per-interval $REQUESTS_PER_INTERVAL --interval-seconds $INTERVAL_SECONDS

        $expected_total_delay_ms += (($INTERVAL_SECONDS * 1000) / $REQUESTS_PER_INTERVAL)
    }
    let $expected_duration = ($expected_total_delay_ms | math round | into duration --unit ms)

    let simulated_duration = ($env.SLEEP_LOG | math sum | into duration)
    let threshold_duration = ( '10ms' | into duration)
    assert ($simulated_duration + $threshold_duration >= $expected_duration)
    assert ($simulated_duration - $threshold_duration <= $expected_duration)
}


#[test]
export def mock_calls_24_calls_per_1min [] {
    const REQUESTS_PER_INTERVAL = 24
    const INTERVAL_SECONDS = 60
    const MOCK_REQUESTS_AMOUNT = $REQUESTS_PER_INTERVAL * 100

    run_delay_test $REQUESTS_PER_INTERVAL $INTERVAL_SECONDS $MOCK_REQUESTS_AMOUNT
}

#[test]
export def mock_calls_10_calls_per_1sec [] {
    const REQUESTS_PER_INTERVAL = 10
    const INTERVAL_SECONDS = 1
    const MOCK_REQUESTS_AMOUNT = $REQUESTS_PER_INTERVAL * 100

    run_delay_test $REQUESTS_PER_INTERVAL $INTERVAL_SECONDS $MOCK_REQUESTS_AMOUNT
}

