# erlang-basic

===String:
join
equals
tokens
str(String, SubString) -> Index
chr(String, Character) -> Index
split(String, SearchPattern) -> [unicode:chardata()]

hd(List) -> Head 
# lists:last(List) -> Last

tl(List) -> List of tail (remove 1st elem)
# droplast -> init list

===lists:
droplast -> init list
nth(N, List) -> Elem : return nth element
nthtail(N, List) -> Tail : remove n first elems, and return the rest
sublist(List1, Len) -> List2 : ~~ take(N,L)
sublist(List1, Start, Len) -> List2
member(Elem, List) -> boolean() : return true if elem in List ~~ elem
partition(Pred, List) -> {Satisfying, NotSatisfying}
splitwith(Pred, List) -> {takewhile(Pred, List), dropwhile(Pred, List)}.
duplicate(N, Elem) -> List
split(N, List1) -> {List2, List3}