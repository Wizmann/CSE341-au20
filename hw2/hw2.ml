(* CSE 341, Autumn 2020, HW2 Provided Code *)

(* main datatype definition we will use throughout the assignment *)
type json =
    Num of float
  | String of string
  | False
  | True
  | Null
  | Array of json list
  | Object of (string * json) list

(* some examples with values with type json *)
let json_pi    = Num 3.14159
let json_hello = String "hello"
let json_false = False
let json_array = Array [Num 1.0; String "world"; Null]
let json_obj   = Object [("foo", json_pi); ("bar", json_array); ("ok", True)]

(* helper function that deduplicate the list *)
let dedup ls = List.sort_uniq compare ls

(* helper function that sort a given list *)
let sort ls = List.sort compare ls

(* We now load 3 files with bus position data represented as values with type json.
   Each file binds one variable: small_bus_positions (10 reports),
   medium_bus_positions (100 reports), and complete_bus_positions (~1000 reports),
   respectively.

   However, the medium and complete files are commented out for now because takes
   a few seconds to load, which is too long while you are debugging
   earlier problems.
*)

;;
#print_depth 3;;
#print_length 3;;

#use "parsed_small_bus.ml";;
(* #use "parsed_medium_bus.ml";; *)
(* #use "parsed_complete_bus.ml";; *)

;;
#print_depth 10;;
#print_length 1000;;

let rec range (i: int) (j: int) : int list =
    if i > j then
        []
    else
        i :: (range (i + 1) j)
;;

let rec reverse items : 'a list =
    match items with
    | [] -> []
    | hd :: tl -> reverse(tl) @ [ hd ]
;;

(* Part 0: Warm-up *)

(* Problem 1
 * Write a function make_silly_json that takes an int i and returns a json.
 * The result should represent a JSON array of JSON objects where every object
 * in the array has two fields, "n" and "b". Every object's "b" field should hold
 * true (i.e., True). The first object in the array should have a "n" field holding
 * the JSON number i.0 (in other words, the integer i converted to a floating point
 * JSON number), the next object should have an "n" field holding (i - 1).0 and so on
 * where the last object in the array has an "n" field holding 1.0.
 * Sample solution is less than 10 lines. Hints: There's a function in OCaml's
 * standard library called float_of_int that converts an integer to a float.
 * You'll want a helper function that does most of the work.
*)

let make_silly_json(n: int) : json = 
    Array (range 1 n |> reverse |> List.map (fun i -> Object [("n", Num (float_of_int i)); ("b", True)]))
;;

(* Part 1: Printing JSON values *)

(* OCaml's string_of_float is not quite RFC compliant due to its tendency
   to output whole numbers with trailing decimal points without a zero.
   But, printf does the job. *)
let json_string_of_float (f : float) : string =
  Printf.sprintf "%g" f

(**** PUT PROBLEMS 2-4 HERE ****)

(* Problem 2
 * Write a function concat_with that takes a separator string and a list of strings,
 * and returns the string that consists of all the strings in the list concatenated
 * together, separated by the separator. The separator should be only between elements,
 * not at the beginning or end. Use OCaml's ^ operator for concatenation (e.g.,
 * "hello" ^ "world" evaluates to "helloworld"). Sample solution is 5 lines.
*)

let rec concat_with (delimeter: string) (strs: string list) : string =
    match strs with
    | [] -> ""
    | hd :: [] -> hd
    | hd :: tl -> hd ^ delimeter ^ (concat_with delimeter tl)
;;

(* Problem 3
 * Write a function quote_string that takes a string and returns a string that is the
 * same except there is an additional '"' character (a single quote character) at the
 * beginning and end.
 * Sample solution is 1 line.
*)

let quote_string(str: string) : string =
    "\"" ^ str ^ "\""
;;

(* Problem 4
 * Write a function string_of_json that converts a json into the proper string encoding in
 * terms of the syntax described on the first page of this assignment. The two previous
 * problems are both helpful, but you will also want local helper functions for processing
 * arrays and objects (hint: in both cases, create a string list that you then pass to concat_with).
 * In the Num case, use the provided json_string_of_float function.
 * Sample solution is 25 lines.
*)

let rec string_of_json(obj: json) : string =
    let rec make_key_value (kv: string * json) : string =
        match kv with
        | (key, value) -> (quote_string key) ^ " : " ^ (string_of_json value)
    in

    match obj with
    | Num (num) -> (json_string_of_float num)
    | String (str) -> (quote_string str)
    | False -> "false"
    | True -> "true"
    | Null -> "null"
    | Array (sub_objs) -> "[" ^ (concat_with ", " (List.map string_of_json sub_objs)) ^ "]"
    | Object (sub_objs) -> "{" ^ (concat_with ", " (List.map make_key_value sub_objs)) ^ "}"

(* Part 2: Processing JSON values *)

(* Types for use in problems 17-20. *)
type rect = { min_latitude: float; max_latitude: float;
              min_longitude: float; max_longitude: float }
type point = { latitude: float; longitude: float }

(**** PUT PROBLEMS 5-20 HERE ****)

(* Don't forget to write a comment for problems 7 and 20. *) 

(* Problem 5
 * Write a function take of type int * 'a list -> 'a list that takes an int called n and
 * a list called l and returns the first n elements of l in the same order as l. You may
 * assume that n is non-negative and does not exceed the length of l.
 * Sample solution is about 5 lines.
*)

let rec take (n: int) (l: 'a list) : 'a list =
    match l with
    | [] -> ignore(assert(n = 0)); []
    | hd :: tl -> 
            if n = 0 then [] else hd :: (take (n - 1)  tl)
;;

(* Problem 6
 * Write a function firsts of type ('a * 'b) list -> 'a list that takes a list of pairs
 * and returns a list of all the first components of the pairs in the same order as the
 * argument list.
 * Sample solution is about 4 lines.
*)
let rec firsts(pairs : ('a * 'b) list) : 'a list =
    match pairs with
    | [] -> []
    | (item1, item2) :: tl -> item1 :: firsts(tl)

(* Problem 7
 * Write a comment in your file after your definition of firsts answering the following
 * questions. Suppose l has type (int * int) list, and let n be an integer between 0 and
 * the length of l (inclusive), and consider the expressions firsts (take (n, l)) and
 * take (n, firsts l). Either (1) write one sentence explaining in informal but precise
 * English why these two expressions always evaluate to the same value; or (2) give example
 * values of l and n such that the two expressions evaluate to different values.
 * Regardless of whether you decide option (1) or option (2) is correct, also write one
 * sentence explaining which of the two expressions above might be faster to evaluate and why.
*)

(* Answer for Problem 7:
 *
 * Assuming we have a list `l` which `length(l) >= n + 1`,
 * and a function `nth` to retrieve the nth element of the list.

 * It's easy for us to know that:
 * ```
 * f(n) = (firsts (take n l)) = (firsts (take n l)) @ (firsts (nth (n + 1) l))
 * g(n) = (take n (firsts l)) = (take n (firsts l)) @ (firsts (nth (n + 1) l))
 * ```

 * It means for a specific length `n`, if f(n) = g(n), we can prove f(n + 1) = g(n + 1).
 * And it's trival that f(0) = g(0). We can use mathmatical induction to prove that
 * for every n, there will be f(n) = g(n)
*)

(* Problem 8
 * Write a function assoc of type 'a * ('a * 'b) list -> 'b option that takes two arguments
 * k and xs. It should return Some v1 if (k1,v1) is the pair in the list closest to the beginning
 * of the list for which k and k1 are equal. If there is no such pair, assoc returns None.
 * Sample solution is a few lines. (Note: There's a function with similar functionality in the
 * OCaml standard library, but calling it requires features we haven't covered yet.
 * Do not use that function or you will not receive credit.)
*)

let rec assoc (key : 'a) (xs : ('a * 'b) list) : 'b option =
    match xs with
    | [] -> None
    | (k, v) :: tl -> if key = k then Some v else (assoc key tl)
;;

(* Problem 9
 * Write a function dot that takes a json (call it j) and a string (call it f) and returns a
 * json option. 
 * If j is an object that has a field named f, then return Some v where v is the contents of
 * that field.
 * If j is not an object or does not contain a field f, then return None.
 * Sample solution is 4 short lines thanks to an earlier problem.
*)

let rec dot (j : json) (f : string) : json option =
    match j with
    | Object (hd :: tl) -> if fst(hd) = f then (Some (snd hd))
                           else (dot (Object tl) f)
    | _ -> None

(* Problem 10
 * Write a function dots that takes a json called j and a string list called fs that represents
 * an access path, or in other words, a list of field names. The function dots returns a json option
 * by recursively accessing the fields in fs, starting at the beginning of the list. If any of the
 * field accesses occur on non-objects, or to fields that do not exist, return None.
 * Otherwise, return Some v where v is the value of the field "pointed to" by the access path.
 * (Hint: Use recursion on fs plus your solution to the previous problem.)
 * Sample solution is about 7 lines.
*)


(* histogram and histogram_for_access_path are provided, but they use your
   count_occurrences and string_values_for_access_path, so uncomment them
   after doing earlier problems *)
exception SortIsBroken

(* 
let histogram (xs : string list) : (string * int) list =
  let sorted_xs = List.sort (fun a b -> compare a b) xs in
  let counts = count_occurrences (sorted_xs,SortIsBroken) in
  let compare_counts ((s1 : string), (n1 : int)) ((s2 : string), (n2 : int)) : int =
    if n1 = n2 then compare s1 s2 else compare n1 n2
  in
  List.rev (List.sort compare_counts counts)

let histogram_for_access_path (fs, js) =
  histogram (string_values_for_access_path (fs, js))
*)

(* The definition of the U district for purposes of this assignment :) *)
let u_district =
  { min_latitude = 47.648637;
    min_longitude = -122.322099;
    max_latitude = 47.661176;
    max_longitude = -122.301019
  }

(* Part 3: Analyzing the data *)

;;
#print_depth 3;;
#print_length 3;;

(* uncomment these lines *and* the lines at the top of the file that load "parsed_complete_bus.ml"
   when ready to work on part 3 *)
(* 
let complete_bus_positions_list =
  match dot(complete_bus_positions, "entity") with
  | Some (Array l) -> l
  | _ -> failwith "complete_bus_positions_list"
*)
;;
#print_depth 10;;
#print_length 1000;;

(**** PUT PROBLEMS 21-26 HERE ****)

(* see hw2challenge.ml for challenge problems *)
