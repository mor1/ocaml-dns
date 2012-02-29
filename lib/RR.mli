(*
 * Copyright (c) 2005-2006 Tim Deegan <tjd@phlegethon.org>
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
 *
 *)

(** Datatypes and handling for DNS Resource Records and RRSets. 

    @author Tim Deegan
    @author Richard Mortier <mort\@cantab.net> (documentation)
*)
open Types

(** Construct a {! Hashcons} character-string from a string. *)
val hashcons_charstring : string -> cstr

(** Construct a {! Hashcons} domain name (list of labels) from a domain
    name. *)
val hashcons_domainname : string list -> string list Hashcons.hash_consed

(** Clear the {! Hashcons} table. *)
val clear_cons_tables : unit -> unit

(** Extract relevant RRSets given a query type, a list of RRSets and a flag to
    say whether to return CNAMEs too. 

    @return the list of extracted {! rrset}s *)
val get_rrsets : 
  [> `A | `AAAA | `AFSDB | `ANY | `CNAME | `HINFO | `ISDN | `MAILB | `MB 
  | `MG | `MINFO | `MR | `MX | `NS | `PTR | `RP | `RT | `SOA 
  | `SRV | `TXT | `UNSPEC | `Unknown of int * string | `WKS | `X25 ] -> 
  rrset list -> bool -> rrset list

(** Merge a new RRSet into a list of RRSets, reversing the order of the RRsets
    in the list.

    @return the new list and the TTL of the resulting RRset. *)
val merge_rrset : rrset -> rrset list -> int32 * rrset list
