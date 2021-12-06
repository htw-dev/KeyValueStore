import type { Principal } from '@dfinity/principal';
export type Result = { 'ok' : string } |
  { 'err' : string };
export interface Store {
  'delete' : (arg_0: string) => Promise<Result>,
  'get' : (arg_0: string) => Promise<Result>,
  'getAll' : (arg_0: bigint, arg_1: bigint) => Promise<string>,
  'put' : (arg_0: string, arg_1: string) => Promise<Result>,
}
export interface _SERVICE extends Store {}
