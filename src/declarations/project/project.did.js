export const idlFactory = ({ IDL }) => {
  const Result = IDL.Variant({ 'ok' : IDL.Text, 'err' : IDL.Text });
  const Store = IDL.Service({
    'delete' : IDL.Func([IDL.Text], [Result], []),
    'get' : IDL.Func([IDL.Text], [Result], ['query']),
    'getAll' : IDL.Func([IDL.Nat, IDL.Nat], [IDL.Text], []),
    'put' : IDL.Func([IDL.Text, IDL.Text], [Result], []),
  });
  return Store;
};
export const init = ({ IDL }) => { return []; };
