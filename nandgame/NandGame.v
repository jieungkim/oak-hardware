(****************************************************************************)
(* Copyright 2020 The Project Oak Authors                                   *)
(*                                                                          *)
(* Licensed under the Apache License, Version 2.0 (the "License")           *)
(* you may not use this file except in compliance with the License.         *)
(* You may obtain a copy of the License at                                  *)
(*                                                                          *)
(*     http://www.apache.org/licenses/LICENSE-2.0                           *)
(*                                                                          *)
(* Unless required by applicable law or agreed to in writing, software      *)
(* distributed under the License is distributed on an "AS IS" BASIS,        *)
(* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. *)
(* See the License for the specific language governing permissions and      *)
(* limitations under the License.                                           *)
(****************************************************************************)

(* Cava implementations of the gates described in the Nand Game website
   which describes how to build circuit components using only NAND gates
   and registers. http://nandgame.com/
*)

From Coq Require Import Bool.Bool.
From Coq Require Import Ascii String.
From Coq Require Import Lists.List.
Import ListNotations.

Require Import Hask.Control.Monad.

Require Import Cava.

Local Open Scope list_scope.
Local Open Scope monad_scope.

(******************************************************************************)
(* Build an inverter using only NAND gates.                                   *)
(******************************************************************************)

Definition inverter {m t} `{Cava m t} a := nand_gate [a; a].

Definition inverterTop {m t} `{CavaTop m t} :=
  setModuleName "invertor" ;;
  a <- input "a" ;
  b <- inverter a ;
  output "b" b.

Definition inverterNetlist := makeNetlist inverterTop.

(* A proof that the NAND-gate based implementation of the inverter is correct. *)
Lemma inverter_behaviour : forall (a : bool),
                           combinational (inverter a) = negb a.
Proof.
  intros.
  unfold combinational.
  unfold fst.
  simpl.
  rewrite andb_diag.
  reflexivity.
Qed.

(******************************************************************************)
(* Build an AND-gate using only NAND gates.                                   *)
(******************************************************************************)

Definition andgate {m t} `{Cava m t}  a b :=
  x <- nand_gate [a; b] ;
  c <- inverter x ;
  return_ c.

Definition andgateTop {m t} `{CavaTop m t} :=
  setModuleName "andgate" ;;
  a <- input "a" ;
  b <- input "b" ;
  c <- andgate a b ;
  output "c" c.

Definition andgateNetlist := makeNetlist andgateTop.

(* A proof that the NAND-gate based implementation of the AND-gate is correct. *)
Lemma andgate_behaviour : forall (a : bool) (b : bool),
                          combinational (andgate a b) = a && b.
Proof.
  intros.
  unfold combinational.
  unfold fst.
  simpl.
  rewrite andb_diag.
  rewrite negb_involutive.
  reflexivity.
Qed.

(******************************************************************************)
(* Build an OR-gate using only NAND gates.                                    *)
(******************************************************************************)

Definition orgate {m t} `{Cava m t} a b :=
  nota <- inverter a;
  notb <- inverter b;
  c <- nand_gate [nota; notb];
  return_ c.

Definition orgateTop {m t} `{CavaTop m t} :=
  setModuleName "orgate" ;;
  a <- input "a" ;
  b <- input "b" ;
  c <- orgate a b ;
  output "c" c.

Definition orgateNetlist := makeNetlist orgateTop.

(* A proof that the NAND-gate based implementation of the AND-gate is correct. *)
Lemma orgate_behaviour : forall (a : bool) (b : bool),
                         combinational (orgate a b) = a || b.
Proof.
  intros.
  unfold combinational.
  unfold fst. 
  simpl.
  rewrite andb_diag.
  rewrite andb_diag.
  rewrite negb_andb.
  rewrite negb_involutive.
  rewrite negb_involutive.
  reflexivity.
Qed.

(******************************************************************************)
(* Build an XOR-gate using only NAND gates.                                   *)
(******************************************************************************)

Definition xorgate {m t} `{Cava m t} a b :=
  nab <- nand_gate [a; b] ;
  x <- nand_gate [a; nab] ;
  y <- nand_gate [nab; b] ;
  c <- nand_gate [x; y] ;
  return_ c.

Definition xorgateTop {m t} `{CavaTop m t} :=
  setModuleName "xorgate" ;;
  a <- input "a" ;
  b <- input "b" ;
  c <- xorgate a b ;
  output "c" c.
Definition xorgateNetlist := makeNetlist xorgateTop.


(* A proof that the NAND-gate based implementation of the XOR-gate is correct. *)
Lemma xorgate_behaviour : forall (a : bool) (b : bool),
                          combinational (xorgate a b) = xorb a b.
Proof.
  intros.
  unfold combinational.
  unfold fst. 
  simpl.
  case a, b.
  all : reflexivity.
Qed.

(******************************************************************************)
(* Build a half-adder                                                         *)
(******************************************************************************)

Definition halfAdder {m t} `{Cava m t} a b :=
  partial_sum <- xorgate a b ;
  carry <- andgate a b ;
  return_ (partial_sum, carry).

Definition halfAdderTop {m t} `{CavaTop m t} :=
  setModuleName "halfadder" ;;
  a <- input "a" ;
  b <- input "b" ;
  ps_c <- halfAdder a b ;
  output "partial_sum" (fst ps_c) ;;
  output "carry" (snd ps_c).

Definition halfAdderNetlist := makeNetlist halfAdderTop.

(* A proof that the NAND-gate based implementation of the half-adder is correct. *)
Lemma halfAdder_behaviour : forall (a : bool) (b : bool),
                            combinational (halfAdder a b) = (xorb a b, a && b).

Proof.
  intros.
  unfold combinational.
  unfold fst.
  simpl.
  case a, b.
  all : reflexivity.
Qed.

   
(******************************************************************************)
(* Build a full-adder                                                         *)
(******************************************************************************)

Definition fullAdder {m t} `{Cava m t} a b cin :=
  abl_abh <- halfAdder a b ;
  abcl_abch <- halfAdder (fst abl_abh) cin ;
  cout <- orgate (snd abl_abh) (snd abcl_abch) ;
  return_ (fst abcl_abch, cout).

Definition fullAdderTop {m t} `{CavaTop m t} :=
  setModuleName "fulladder" ;;
  a <- input "a" ;
  b <- input "b" ;
  cin <- input "cin" ;
  sum_cout <- fullAdder a b cin ;
  output "sum" (fst sum_cout) ;;
  output "carry" (snd sum_cout).


Definition fullAdderNetlist := makeNetlist fullAdderTop.

(* A proof that the NAND-gate based implementation of the full-adder is correct. *)
Lemma fullAdder_behaviour : forall (a : bool) (b : bool) (cin : bool),
                            combinational (fullAdder a b cin)
                              = (xorb cin (xorb a b),
                                 (a && b) || (b && cin) || (a && cin)).
Proof.
  intros.
  unfold combinational.
  unfold fst.
  simpl.
  case a, b, cin.
  all : reflexivity.
Qed.