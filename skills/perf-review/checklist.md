# Performance Checklist by Language

Organised to reflect the review categories in SKILL.md. Each section covers the same concerns with language-specific patterns.

## JavaScript / TypeScript

### Algorithmic complexity
- Avoid `Array.find()` or `Array.includes()` in hot loops — use `Map` or `Set` for O(1) lookups
- Watch for nested `.filter().map()` chains that iterate the same array multiple times — combine into a single `.reduce()`
- Avoid regex compilation inside loops — compile once and reuse

### Batching
- Use `Promise.all()` for independent async operations instead of sequential `await`
- Batch DOM updates — use `DocumentFragment` or framework batching (React automatic batching, Vue `nextTick`)
- Batch API calls with bulk endpoints instead of looping over individual requests

### Caching
- Memoize expensive pure functions with a cache map or libraries like `lru-cache`
- Use `useMemo` / `useCallback` in React to avoid recomputing on every render
- Cache API responses client-side where data doesn't change frequently

### Data structures
- Use `Map` over plain objects for frequent additions/deletions — `Map` is optimised for this
- Use `Set` instead of arrays for membership checks
- Use `TypedArray` (`Float64Array`, `Uint8Array`) for numerical data over regular arrays

### Memory
- Watch for accidental closures capturing large scopes
- Remove event listeners and clear intervals/timeouts on cleanup
- Avoid building large strings with `+=` in loops — use `Array.join()`

### Concurrency
- Use `Promise.all()` for independent I/O, `Promise.allSettled()` when partial failure is acceptable
- Use Web Workers or worker threads for CPU-bound tasks off the main thread
- Watch for unbounded `Promise.all()` on large arrays — use a concurrency limiter (e.g. `p-limit`)

### I/O efficiency
- Use streaming APIs (`ReadableStream`, Node `stream.pipeline`) for large payloads
- Enable HTTP keep-alive and connection pooling for repeated requests
- Avoid synchronous `JSON.parse()` / `JSON.stringify()` on large payloads — consider streaming parsers

### Lazy vs eager evaluation
- Use generators (`function*`) for large sequences consumed incrementally
- Prefer `Array.some()` / `Array.every()` over `.filter().length` for existence checks — they short-circuit
- Lazy-load modules with dynamic `import()` instead of importing everything upfront

### Hot paths
- Avoid unintentional re-renders in React — missing `useMemo`, `useCallback`, unstable object/array references as props
- Avoid creating new objects or closures inside render paths
- Prefer `for` loops over `.forEach()` / `.map()` in performance-critical tight loops

### Language-specific antipatterns
- `for...in` on arrays iterates over all enumerable properties, not just indices — use `for...of`
- `delete obj[key]` makes objects polymorphic and deoptimises V8 — use `Map` or set to `undefined`
- Excessive spread (`{...obj}`) creates shallow copies on every call — avoid in hot paths

## Python

### Algorithmic complexity
- Avoid repeated `in` checks on lists — convert to `set` for O(1) membership
- Use `collections.Counter` instead of manual counting loops
- Use `bisect` for sorted searches instead of linear scans

### Batching
- Batch database inserts with `executemany()` or ORM bulk methods (`bulk_create`, `bulk_update`)
- Batch API calls with `asyncio.gather()` or `concurrent.futures`
- Use `cursor.copy_from()` / `COPY` for large PostgreSQL inserts instead of row-by-row

### Caching
- Use `functools.lru_cache` or `functools.cache` for memoising pure functions
- Use `functools.cached_property` for expensive computed properties
- Cache external API responses with TTL using `cachetools` or Redis

### Data structures
- Use `collections.defaultdict` or `Counter` instead of manual dictionary accumulation
- Use `set` instead of `list` for membership tests
- Use `deque` for queue operations — `list.pop(0)` is O(n)

### Memory
- Replace list comprehensions with generator expressions for large datasets consumed once
- Use `__slots__` on data-heavy classes to reduce per-instance memory
- Avoid string concatenation in loops — use `"".join()` or `io.StringIO`

### Concurrency
- Use `asyncio.gather()` for concurrent I/O-bound tasks
- Use `concurrent.futures.ProcessPoolExecutor` for CPU-bound work to bypass the GIL
- Watch for thread-safety issues with shared mutable state in `ThreadPoolExecutor`

### I/O efficiency
- Use connection pooling for database and HTTP connections (`SQLAlchemy` pool, `httpx` client)
- Stream large files with chunked reads instead of `file.read()`
- Use `orjson` or `ujson` for faster JSON serialisation/deserialisation

### Lazy vs eager evaluation
- Use generators and `itertools` for pipeline processing of large datasets
- Prefer `itertools.islice()` over list slicing when you only need a portion
- Use `any()` / `all()` for short-circuit evaluation instead of processing the full iterable

### Hot paths
- Avoid attribute lookups in tight loops — bind to a local variable (`append = list.append`)
- Use list comprehensions over `for` + `append` — they are compiled to faster bytecode
- Avoid `**kwargs` unpacking in hot paths — direct arguments are faster

### Language-specific antipatterns
- Watch for N+1 queries in Django/SQLAlchemy ORM loops — use `select_related` / `prefetch_related` / `joinedload`
- Avoid global interpreter lock contention by preferring multiprocessing for CPU work
- Avoid `isinstance()` checks in tight loops — consider structural pattern matching or polymorphism

## Go

### Algorithmic complexity
- Avoid linear searches in slices for lookup-heavy operations — use `map[K]V`
- Preallocate slices with `make([]T, 0, cap)` when the size is known or estimable
- Avoid repeated `sort.Search` — maintain a sorted structure or use a map

### Batching
- Batch database operations with `pgx.Batch` or multi-row `INSERT` statements
- Use channel-based fan-out/fan-in for parallel batch processing
- Accumulate writes and flush periodically instead of writing one at a time

### Caching
- Use `sync.Map` for read-heavy concurrent caches
- Use `sync.Once` for one-time expensive initialisations
- Consider `groupcache` or `ristretto` for in-process LRU caches

### Data structures
- Use `map` for O(1) lookups instead of iterating slices
- Use `sync.Pool` for frequently allocated/freed objects to reduce GC pressure
- Use `container/heap` for priority queue operations instead of re-sorting slices

### Memory
- Avoid unnecessary allocations in hot paths — preallocate slices and reuse buffers
- Watch for string-to-byte conversions in loops — each creates a copy
- Be careful with slice reslicing — the underlying array stays alive if any slice references it

### Concurrency
- Watch for goroutine leaks — ensure channels are closed and contexts are cancelled
- Use `errgroup.Group` for structured concurrent work with error propagation
- Avoid unnecessary mutexes — prefer channels for communication, mutexes for protecting state

### I/O efficiency
- Use buffered I/O (`bufio.Reader` / `bufio.Writer`) for file and network operations
- Use `io.Copy` with buffer pools for large transfers instead of reading into memory
- Enable connection pooling in `http.Client` — set `MaxIdleConns` and `MaxIdleConnsPerHost`

### Lazy vs eager evaluation
- Use iterators (Go 1.23+) or channel-based generators for lazy sequences
- Prefer `io.Reader` streaming over loading entire files into memory
- Use `sql.Rows` iteration instead of fetching all rows into a slice

### Hot paths
- Prefer `strings.Builder` over `+` or `fmt.Sprintf` for string building in loops
- Avoid `interface{}` / `any` in performance-critical code — type assertions and reflection have overhead
- Use value receivers on small structs to avoid heap allocation from pointer escape

### Language-specific antipatterns
- `defer` in tight loops — deferred calls accumulate until the function returns
- Using `fmt.Sprintf` for simple concatenation where `+` or `strings.Builder` suffice
- Ignoring `context.Context` cancellation — leads to wasted work and resource leaks

## Rust

### Algorithmic complexity
- Use `HashMap` / `HashSet` for O(1) lookups instead of iterating `Vec`
- Use `Vec::with_capacity()` when the size is known or estimable
- Prefer iterators over index-based loops for compiler optimisation opportunities (bounds check elimination)

### Batching
- Use `write_all()` or `BufWriter` to batch I/O operations instead of many small writes
- Batch database operations with prepared statements and multi-row inserts
- Use `rayon::par_iter()` for data-parallel batch processing

### Caching
- Use `once_cell::Lazy` or `std::sync::LazyLock` for lazily-initialised globals
- Use `cached` crate for function memoisation
- Implement `Hash` efficiently for cache keys — avoid hashing more data than needed

### Data structures
- Use `SmallVec` for collections that are usually small but occasionally large
- Use `Cow<str>` to avoid allocations when data is often borrowed but occasionally owned
- Use `BTreeMap` over `HashMap` when iteration order matters or keys are short

### Memory
- Avoid unnecessary `.clone()` — borrow where possible
- Use `Box<[T]>` instead of `Vec<T>` for fixed-size heap allocations
- Watch for accidental `Box<dyn Trait>` in hot paths — prefer generics for static dispatch

### Concurrency
- Use `rayon` for data parallelism instead of manual thread spawning
- Use `tokio::spawn` for concurrent async tasks, `tokio::task::spawn_blocking` for CPU-bound work
- Prefer lock-free data structures (`crossbeam`) in contention-heavy paths

### I/O efficiency
- Use `BufReader` / `BufWriter` for file I/O
- Use `tokio::io` async readers/writers for network operations
- Prefer `bytes::Bytes` for zero-copy buffer sharing across async tasks

### Lazy vs eager evaluation
- Iterators are lazy by default — chain operations to avoid intermediate collections
- Use `Iterator::take()` and `Iterator::skip()` instead of collecting and slicing
- Use `once_cell` or `LazyLock` for deferred initialisation of expensive values

### Hot paths
- Avoid heap allocation in hot loops — prefer stack-allocated arrays or `SmallVec`
- Use `#[inline]` hints on small functions called across crate boundaries
- Profile before optimising — `cargo flamegraph` and `criterion` for benchmarks

### Language-specific antipatterns
- Unnecessary `.to_string()` / `.to_owned()` when a `&str` borrow would suffice
- Using `Arc<Mutex<T>>` when `Arc<RwLock<T>>` would allow concurrent reads
- Collecting into a `Vec` only to iterate it immediately — just chain the iterator

## Java

### Algorithmic complexity
- Avoid `List.contains()` in loops — use `HashSet` for O(1) membership checks
- Prefer `HashMap.computeIfAbsent()` over check-then-put patterns
- Use `Arrays.sort()` (dual-pivot quicksort) and `Collections.sort()` (TimSort) appropriately

### Batching
- Use JDBC `addBatch()` / `executeBatch()` for bulk database operations
- Batch HTTP requests with `CompletableFuture.allOf()`
- Use `BufferedOutputStream` to batch small writes

### Caching
- Use `Caffeine` or `Guava Cache` for in-process caching with eviction policies
- Use `computeIfAbsent` on `ConcurrentHashMap` for lazy computation
- Cache compiled `Pattern` instances — avoid `String.matches()` which recompiles on every call

### Data structures
- Use `EnumMap` / `EnumSet` for enum-keyed collections — faster than `HashMap`
- Use `ArrayList` over `LinkedList` in almost all cases — better cache locality
- Use `ArrayDeque` over `Stack` or `LinkedList` for stack/queue operations

### Memory
- Avoid autoboxing in loops — use primitive types and specialised collections (`IntStream`, Eclipse Collections)
- Watch for excessive object creation — consider object pooling for short-lived objects in tight loops
- Use `StringBuilder` instead of `+` for string concatenation in loops

### Concurrency
- Use `CompletableFuture` for async composition instead of blocking `Future.get()`
- Use `parallelStream()` only for CPU-bound work on large collections — overhead is significant for small datasets
- Use `ConcurrentHashMap` over `Collections.synchronizedMap` for concurrent access

### I/O efficiency
- Use `BufferedReader` / `BufferedWriter` for file I/O
- Use connection pooling (HikariCP) for database connections
- Prefer NIO channels for high-throughput network I/O

### Lazy vs eager evaluation
- Use `Stream` API — operations are lazy until a terminal operation is called
- Use `Supplier<T>` for deferred computation
- Prefer `Optional.map()` chains over eager `if`-`null` checks with intermediate variables

### Hot paths
- Watch for reflection in hot paths — cache `Method` and `Field` references
- Avoid `String.format()` in hot loops — use `StringBuilder` or direct concatenation
- Watch for unintentional boxing from generic types (`List<Integer>` boxes every `int`)

### Language-specific antipatterns
- `String.split()` compiles a regex on every call — use `Pattern.compile().split()` or `StringTokenizer`
- Catching `Exception` instead of specific types can mask performance-affecting errors
- Using `synchronized` on overly broad scopes — narrow the critical section

## SQL / Database

### Algorithmic complexity
- Missing indexes on foreign key columns or frequently filtered columns
- Missing composite indexes for multi-column `WHERE` clauses
- Using correlated subqueries where a `JOIN` would be more efficient

### Batching
- N+1 query patterns — fetch related data in a single query with `JOIN`s or subqueries
- Use multi-row `INSERT` statements instead of inserting one row at a time
- Batch `UPDATE` / `DELETE` operations with `WHERE IN (...)` or CTEs

### Caching
- Use materialised views for expensive aggregations that don't need real-time data
- Cache query results at the application layer for read-heavy, slowly-changing data
- Use `PREPARE` / prepared statements to avoid repeated query planning

### Data structures
- Use appropriate column types — `JSONB` over `JSON` in PostgreSQL for indexed access
- Use array columns or junction tables appropriately based on query patterns
- Partition large tables by date or key range for query performance

### Memory
- `SELECT *` when only a few columns are needed — wastes memory and network bandwidth
- Missing `LIMIT` on potentially large result sets
- Loading entire result sets into application memory instead of streaming with cursors

### I/O efficiency
- Using `OFFSET` for pagination on large tables — prefer keyset pagination (`WHERE id > ?`)
- Unnecessary `ORDER BY` on unindexed columns forces a full sort
- Missing covering indexes that would allow index-only scans
