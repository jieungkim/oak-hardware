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

Require Import Coq.extraction.Extraction.
Require Import Coq.extraction.ExtrHaskellZInteger.
Require Import Coq.extraction.ExtrHaskellString.
Require Import Coq.extraction.ExtrHaskellBasic.
Require Import Coq.extraction.ExtrHaskellNatInteger.

Extraction Language Haskell.
Set Extraction KeepSingleton.
Set Extraction File Comment "Auto-generated from Cava/Coq. Please do not hand edit.".

Require Import Cava.BitArithmetic.
Require Import Cava.Cava.
Require Import Cava.Kind.
Require Import Cava.Signal.
Require Import Cava.VectorUtils.
Require Import Cava.Acorn.Acorn.
Require Import Cava.Acorn.CombinationalMonad.
Require Import Cava.Acorn.Sequential.
Require Import Cava.Acorn.CavaClass.
Require Import Cava.Acorn.Combinators.
Require Import Cava.Acorn.NetlistGeneration.
Require Import Cava.Acorn.XilinxAdder.

Require Import Cava.Lib.BitVectorOps.
Require Import Cava.Lib.FullAdder.
Require Import Cava.Lib.UnsignedAdders.

Recursive Extraction Library BitArithmetic.
Recursive Extraction Library Cava.
Recursive Extraction Library Acorn.
Recursive Extraction Library CombinationalMonad.
Recursive Extraction Library Sequential.
Recursive Extraction Library Combinators.
Recursive Extraction Library NetlistGeneration.

Require Import Cava.Arrow.ArrowExport.
Require Cava.Arrow.Classes.Category.
Require Cava.Arrow.Classes.Arrow.
Require Cava.Arrow.Classes.Coq.
Require Cava.Arrow.Classes.Kleisli.

Recursive Extraction Library Arrow.
Recursive Extraction Library Category.
Recursive Extraction Library Coq.
Recursive Extraction Library Kleisli.
Recursive Extraction Library ArrowKind.
Recursive Extraction Library Primitives.
Recursive Extraction Library CircuitArrow.
Recursive Extraction Library ExprSyntax.
Recursive Extraction Library ExprSemantics.
Recursive Extraction Library ExprLowering.
Recursive Extraction Library ExprEquiv.
Recursive Extraction Library CavaNotation.
Recursive Extraction Library CircuitSemantics.
Recursive Extraction Library CircuitLowering.
Recursive Extraction Library CircuitProp.

Recursive Extraction Library Netlist.
Recursive Extraction Library Signal.
Recursive Extraction Library Kind.
Recursive Extraction Library Types.
Recursive Extraction Library VectorUtils.
Recursive Extraction Library UnsignedAdders.
Recursive Extraction Library XilinxAdder.

Recursive Extraction Library BitVectorOps.
Recursive Extraction Library FullAdder.
Recursive Extraction Library UnsignedAdders.
