# Token ID resolver for I.Sicily tokens

This is a resolver for token IDs on token elements in the [I.Sicily](https://github.com/ISicily/ISicily) corpus of inscriptions from ancient Sicily.

## I.Sicily token IDs

### Background

I.Sicily token IDs are underlyingly of the form ```ISic012345-6789```, where the first six digits ```012345``` correspond to the document ID; the four digits ```6789``` after the dash correspond to a number assigned to each token in the document. These are sequentially ordered through the document. However, to provide flexibility for the insertion of extra tokens in future, token IDs have a trailing ```0```, giving 9 extra IDs on each side for new tokens. (It is, of course, highly unlikely that all this extra space will be needed.) 

For example ```ISic000001-0020``` would in in principle represent the second token in the document ```ISic000001```.

### Compressing IDs for use in XML documents

Placing such a long ID in an EpiDoc XML document significantly reduces readability. Accordingly, it is desirable to compress the ID, without losing any information. 
In XML documents, therefore, the IDs are compressed to a five-digit string consisting of
upper and lower case Roman characters, i.e. ```A-Z```, ```a-z```. For example, ```ISic000001-0020``` is represented as ```AADkk```.

The compression is simply the numerical part of the underlying ID, as a single string, represented in Base 52, where the characters ```A-Z``` correspond to ```0-25``` in decimal, the characters ```a-z``` correspond to ```26-51```. The procedure is:

1. Remove non-numeric characters: ```ISic000001-0020 -> 0000010020```
2. Convert the resulting decimal number to Base 52: ```0000010020 -> 10020 -> Dkk```
3. Pad the resulting string with the '0' character 'A' to make a five digit string, as necessary: ```Dkk -> AADkk```

### Maxima

A consequence of limiting the Base 52 representation to 5 digits is that the maximum decimal number that can be represented is lower than the theoretical maximum decimal number from an ISicily token ID, i.e. ```ISic999999-9999 -> 9999999999```. 

The maximum Base 52 number is ```zzzzz```, which corresponds to ```380204031 -> ISic038020-4031```.

## Running and building the ID resolver

### On Github Pages

Follow this link:

[https://rsdc2.github.io/ISicID/](https://rsdc2.github.io/ISicID/)

### Running

- Clone the repository:

```
git clone https://github.com/rsdc2/ISicID.git
```

- Open ```index.html``` in a browser

### Building

The ID resolver is written in [PureScript](https://www.purescript.org/), a functional programming language similar to [Haskell](https://www.haskell.org/).

**NB To build, you will need a recent version of [Node.js](https://nodejs.org/en/). It has been tested on Node 20.9.0 LTS.**

To build and run locally:

```
git clone https://github.com/rsdc2/ISicID.git
cd ISicID
npm install
npx spago bundle-app
```

## Acknowledgements

The software for the Token ID resolver was written by Robert Crellin as part of the Crossreads project at the Faculty of Classics, University of Oxford, and is licensed under the BSD 3-clause license. This project has received funding from the European Research Council (ERC) under the European Union’s Horizon 2020 research and innovation programme (grant agreement No 885040, “Crossreads”).

I found the following links helpful on conversion between bases:

- [https://iq.opengenus.org/convert-decimal-to-hexadecimal/](https://iq.opengenus.org/convert-decimal-to-hexadecimal/), last accessed 24th July 2023
- [https://en.wikipedia.org/wiki/Positional_notation#Base_conversion](https://en.wikipedia.org/wiki/Positional_notation#Base_conversion), last accessed 24th July 2023

I found the following links helpful for implementing various features in PureScript:
- [https://stackoverflow.com/questions/70030793/how-do-i-add-an-onclick-listener-in-plain-purescript](https://stackoverflow.com/questions/70030793/how-do-i-add-an-onclick-listener-in-plain-purescript), last accessed 24th July 2023
- [https://github.com/JordanMartinez/purescript-cookbook/blob/master/recipes/GroceriesJs/src/Main.purs](https://github.com/JordanMartinez/purescript-cookbook/blob/master/recipes/GroceriesJs/src/Main.purs), last accessed 24th July 2023
