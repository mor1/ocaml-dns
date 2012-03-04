open Operators
open Uri_IP

(** DNS serial number -- 32 bits. *)
type int16 = int
type byte = char
let byte (i:int) : byte = Char.chr i
let int32_of_byte b = b |> int_of_char |> Int32.of_int

type bytes = string
let bytes_of_bitstring bits = Bitstring.string_of_bitstring bits

type domain_name = string list
type label = 
  | L of string * int (* string *)
  | P of int * int (* pointer *)
  | Z of int (* zero; terminator *)

(** Character-string, memoised via {! Hashcons}. *)
(* Mnemonicity! *)
type serial = int32
type cstr = string Hashcons.hash_consed

(** A resource record. 

    NB. These are as stored in the DNS trie, which associates lists of
    payloads with each type in an attempt at a compact representation. As only
    one payload of each type can be marshalled into an RR in a packet, this
    necessitates a two-phase marshalling process. To prevent type collisions,
    {! Packet} represents each RR as a variant type with the same name.
*)
type rdata = 
  | A of ipv4 list (* always length = 1 *)
  | NS of dnsnode list
(* MD type MF are obsolete; use MX for them *)
  | CNAME of dnsnode list
  | SOA of (dnsnode * dnsnode * serial * int32 * int32 * int32 * int32) list
  | MB of dnsnode list
  | MG of dnsnode list
  | MR of dnsnode list
  | WKS of (int32 * int * cstr) list 
  | PTR of dnsnode list
  | HINFO of (cstr * cstr) list
  | MINFO of (dnsnode * dnsnode) list
  | MX of (int * dnsnode) list 
  | TXT of (cstr list) list
  | RP of (dnsnode * dnsnode) list
  | AFSDB of (int * dnsnode) list
  | X25 of cstr list
  | ISDN of (cstr * cstr option) list
  | RT of (int * dnsnode) list
  | AAAA of cstr list
  | SRV of (int * int * int * dnsnode) list
  | UNSPEC of cstr list
  | Unknown of int * cstr list

(** An RRset, comprising a 32 bit TTL type an {!type: rdata} record. *)
and rrset = {
    ttl: int32;
    rdata: rdata; 
  }

(** A node in the trie. *)
and dnsnode = { 
  (** The name for which the node contains memoised attributes. *)
  owner : domain_name Hashcons.hash_consed;
  (** The set of attributes as  resource records. *)
  mutable rrsets : rrset list; 
} 

type rr_type = [
| `A | `NS | `MD | `MF | `CNAME | `SOA | `MB | `MG | `MR | `NULL 
| `WKS | `PTR | `HINFO | `MINFO | `MX | `TXT | `RP | `AFSDB | `X25 
| `ISDN | `RT | `NSAP | `NSAP_PTR | `SIG | `KEY | `PX | `GPOS | `AAAA 
| `LOC | `NXT | `EID | `NIMLOC | `SRV | `ATMA | `NAPTR | `KM | `CERT 
| `A6 | `DNAME | `SINK | `OPT | `APL | `DS | `SSHFP | `IPSECKEY 
| `RRSIG | `NSEC | `DNSKEY | `SPF | `UINFO | `UID | `GID | `UNSPEC
| `Unknown of int * bytes
]

type rr_rdata = [
| `A of int32
| `NS of domain_name
| `MD of domain_name
| `MF of domain_name
| `CNAME of domain_name
| `SOA of 
    domain_name * domain_name * int32 * int32 * int32 * int32 * int32 
| `HINFO of string * string
| `MB of domain_name
| `MG of domain_name
| `MR of domain_name
| `MINFO of domain_name * domain_name
| `MX of int16 * domain_name
| `PTR of domain_name
| `TXT of string list
| `WKS of int32 * byte * string
| `RP of domain_name * domain_name
| `AFSDB of int16 * domain_name
| `X25 of string
| `ISDN of string
| `RT of int16 * domain_name
| `AAAA of bytes
| `SRV of int16 * int16 * int16 * domain_name
| `UNSPEC of bytes
| `UNKNOWN of int * bytes
]

type rr_class = [ `IN | `CS | `CH | `HS ]
type q_type = [ rr_type | `AXFR | `MAILB | `MAILA | `ANY | `TA | `DLV ]
type q_class = [ rr_class | `NONE | `ANY ]
type qr = [ `Query | `Answer ]
type opcode = [ qr | `Status | `Reserved | `Notify | `Update ]

type rcode = [
| `NoError  | `FormErr
| `ServFail | `NXDomain | `NotImp  | `Refused
| `YXDomain | `YXRRSet  | `NXRRSet | `NotAuth
| `NotZone  | `BadVers  | `BadKey  | `BadTime
| `BadMode  | `BadName  | `BadAlg 
]

type rsrc_record = {
  rr_name  : domain_name;
  rr_class : rr_class;
  rr_ttl   : int32;
  rr_rdata : rr_rdata;
}

type question = {
  q_name  : domain_name;
  q_type  : q_type;
  q_class : q_class;
}

type detail = {
  qr: qr;
  opcode: opcode;
  aa: bool; 
  tc: bool; 
  rd: bool; 
  ra: bool;
  rcode: rcode;
}

type dns = {
  id          : int16;
  detail      : Bitstring.t;
  questions   : question list;
  answers     : rsrc_record list;
  authorities : rsrc_record list;
  additionals : rsrc_record list;
}
