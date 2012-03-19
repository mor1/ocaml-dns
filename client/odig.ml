(*
 * Copyright (c) 2012 Richard Mortier <mort@cantab.net>
 * Copyright (c) 2012 Haris Rotsos <charalampos.rotsos@cl.cam.ac.uk>
 * Copyright (c) 2012 Anil Madhavapeddy <anil@recoil.org>
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

open Lwt
open Dns.Operators
open Printf
open Re_str
open Uri_IP

module DP = Dns.Packet

let usage () = 
  eprintf "Usage: %s <domain-name>\n%!" Sys.argv.(0); 
  exit 1

let t s = 
  lwt ans = Dns_resolver.gethostbyname s in 
  let s = (ans ||> ipv4_to_string |> String.concat "; ") in
  printf "%s\n%!" s;
  return ()
           
let _ = Lwt_unix.(run (t Sys.argv.(1) <&> t Sys.argv.(2) ))