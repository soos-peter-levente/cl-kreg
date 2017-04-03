# cl-kreg
Simple k-regular random graph generation

## Usage

Place it in your central repository and load it with

`(require :cl-kreg)`

or

`(asdf:load-system :cl-kreg)`

Then

```
(cl-kreg:make-random-graph 3 30)
```

which will return  `struct`. A few helpers to convert it:

- `graph->list`
- `graph->hash-table`
- `graph->dot`

## Possible ToDo:

- At this code size, the most immediate drawback I can think of is that as `k` and `n` both grow, the number of retries will tend to increase quickly, which could definitely be improved.

## Thanks

to Edi Weitz for gracious advice about data structures.
