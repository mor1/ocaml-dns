(*
 * Copyright (c) 2012 Richard Mortier <mort@cantab.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

open Dns.Name
open Dns.Packet
open Dns.Protocol
open Cstruct

type t = {
  client : (module CLIENT);
  servers : (string * int) list;
  search_domains : string list;
}

(** Defines the location of the stub resolvers to use for
    client resolution. *)
type config = [
  | `Resolv_conf of string  (** A [resolv.conf] filename *)
  | `Static of (string * int) list * string list (** A list of [hostname,port] of stub resolvers, and a search domain list *)
]

(** Create a resolver instance that either uses the system
    [/etc/resolv.conf], or a statically specified preference
  *)
val create : ?client:(module CLIENT) -> ?config:config -> unit -> t Lwt.t

(** Lookup a {! domain_name }.
    @return the corresponding IPv4 addresses.
*)
val gethostbyname : t -> ?q_class:q_class -> ?q_type:q_type
  -> string -> Ipaddr.V4.t list Lwt.t

(** Reverse lookup an IPv4 address.
    @return the corresponding {! domain_name }s.
*)
val gethostbyaddr : t -> ?q_class:q_class -> ?q_type:q_type
  -> Ipaddr.V4.t -> string list Lwt.t

(** Resolve a fully specified query, {! q_class }, {! q_type } and {!
    domain_name }.
    @return the full a {! dns } structure.
*)
val resolve : t -> ?dnssec:bool -> q_class -> q_type ->
  domain_name -> Dns.Packet.t Lwt.t
