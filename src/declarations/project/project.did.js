export const idlFactory = ({ IDL }) => {
  const Result = IDL.Variant({ 'ok' : IDL.Text, 'err' : IDL.Text });
  const Store = IDL.Service({
    'addOwner' : IDL.Func([IDL.Text], [], []),
    'delete' : IDL.Func([IDL.Text], [Result], []),
    'get' : IDL.Func([IDL.Text], [Result], []),
    'getOwners' : IDL.Func([], [], []),
    'put' : IDL.Func([IDL.Text, IDL.Text], [Result], []),
  });
  return Store;
};
export const init = ({ IDL }) => { return []; };
