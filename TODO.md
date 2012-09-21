Before a 1.0 release, we need:

+ Need resolver lib_tests
+ Parameterise on Lwt/Mirage/Async by functorising lib/
+ Bitstring vs cstruct vs OS gethostbyname performance tests
+ Test cases for odd compression: forward refs, back refs, infinite cycles
+ EDNS parsing (`RR_OPT`) is currently broken due to RR_OPT records treating
  `rr_class` differently (RFC2671 - `rr_class` encodes the UDP payload size,
  `ttl` encodes extended `RCODE` and flags)
