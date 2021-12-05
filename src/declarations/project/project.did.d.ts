import type { Principal } from '@dfinity/principal';
export type Result = { 'ok' : string } |
  { 'err' : string };
export interface Store {
  'addOwner' : (arg_0: string) => Promise<undefined>,
  'delete' : (arg_0: string) => Promise<Result>,
  'get' : (arg_0: string) => Promise<Result>,
  'getOwners' : () => Promise<undefined>,
  'put' : (arg_0: string, arg_1: string) => Promise<Result>,
}
export interface _SERVICE extends Store {}
