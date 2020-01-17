/-
Copyright (c) 2019 Microsoft Corporation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Leonardo de Moura
-/
prelude
import Init.Lean.Meta.Basic

namespace Lean
namespace Meta

def mkFreshExprSyntheticOpaqueMVar (type : Expr) (userName : Name := Name.anonymous) : MetaM Expr :=
mkFreshExprMVar type userName MetavarKind.syntheticOpaque

def throwTacticEx {α} (tacticName : Name) (mvarId : MVarId) (msg : MessageData) : MetaM α := do
throwEx $ fun ctx => Exception.tactic tacticName mvarId (MessageData.withContext ctx msg) ctx

def checkNotAssigned (mvarId : MVarId) (tacticName : Name) : MetaM Unit :=
whenM (isExprMVarAssigned mvarId) $ throwTacticEx tacticName mvarId "metavariable has already been assigned"

def getMVarType (mvarId : MVarId) : MetaM Expr := do
mvarDecl ← getMVarDecl mvarId;
pure mvarDecl.type

@[init] private def regTraceClasses : IO Unit :=
registerTraceClass `Meta.Tactic

end Meta
end Lean
