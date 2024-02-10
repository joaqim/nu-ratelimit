use std assert

use ../queue.nu
export-env { $env._RATELIMIT_QUEUE_LIST = [ ] }

#[test]
export def basic_queue_functionality [] {
    assert equal (queue size) 0
    queue enqueue "Entry 1"
    assert equal (queue size) 1
    queue enqueue "Entry 2"

    assert equal (queue queue_list) ["Entry 1", "Entry 2"]
    assert equal (queue size) 2
    assert equal (queue dequeue) "Entry 1"
    assert equal (queue size) 1
    assert equal (queue dequeue) "Entry 2"
    assert equal (queue size) 0
}