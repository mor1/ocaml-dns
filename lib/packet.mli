(*
 * Copyright (c) 2011 Richard Mortier <mort@cantab.net>
 * Copyright (c) 2011 Anil Madhavapeddy <anil@recoil.org>
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

open Types

(** Raised when a parse error is encountered. *)
exception Unparsable of string * Bitstring.bitstring

val int_of_rr_type : rr_type -> int
val rr_type_of_int : int -> rr_type
val string_of_rr_type : rr_type -> string

val string_of_rdata : [> `A of int32 | `NS of string list ] -> string
val parse_rdata : (int, label) Hashtbl.t -> int -> rr_type -> Bitstring.bitstring -> rr_rdata

val int_of_rr_class : rr_class -> int
val rr_class_of_int : int -> rr_class
val string_of_rr_class : rr_class -> string

val rr_to_string : rsrc_record -> string
val parse_rr : (int, label) Hashtbl.t -> int -> Bitstring.bitstring -> rsrc_record * (string * int * int)

val int_of_q_type : q_type -> int
val q_type_of_int : int -> q_type
val string_of_q_type : q_type -> string

val int_of_q_class : q_class -> int
val q_class_of_int : int -> q_class
val string_of_q_class : q_class -> string

val question_to_string : question -> string
val parse_question : (int, label) Hashtbl.t -> int -> Bitstring.bitstring -> question * (string * int * int)

val qr_of_bool : bool -> qr
val bool_of_qr : qr -> bool

val opcode_of_int : int -> opcode 
val int_of_opcode : opcode -> int

val rcode_of_int : int -> rcode
val int_of_rcode : rcode -> int
val string_of_rcode : rcode -> string

val detail_to_string : detail -> string
val parse_detail : string * int * int -> detail
val build_detail : detail -> Bitstring.bitstring

val dns_to_string : dns -> string
val parse_dns : (int, label) Hashtbl.t -> Bitstring.bitstring -> dns
val marshal : dns -> Bitstring.bitstring
