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
open Dns.Name
open Cstruct
module DP = Dns.Packet

let usage () = 
  eprintf "Usage: %s <domain-name>\n%!" Sys.argv.(0); 
  exit 1

let lookup_name s = 
  lwt ans = Resolver_lwt_unix.gethostbyname s in 
  let ans = (ans ||> Cstruct.ipv4_to_string |> String.concat "; ") in
  printf "%s -> %s\n%!" s ans;
  return ()
           
let lookup_addr s = 
  lwt ans = Resolver_lwt_unix.gethostbyaddr s in
  printf "%s -> %s\n%!" (ipv4_to_string s) (String.concat "; " ans);
  return ()
           
let _ = 
  let threads = 
    Sys.argv |> Array.to_list |> List.tl 
      ||> (fun s -> match Re.execp Uri_re.ipv4_address s with
          | true -> (* lookup_addr s *) return ()
          | false -> lookup_name s
      ) 
  in 
  Lwt_unix.(run (Lwt.join threads))
