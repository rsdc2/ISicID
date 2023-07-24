# Token ID resolver for I.Sicily tokens

This is a resolver for token IDs on token elements in the [I.Sicily]{https://github.com/ISicily/ISicily} corpus of inscriptions from ancient Sicily.

## I.Sicily token IDs

I.Sicily token IDs are underlyingly of the form ```ISicXXXXXX-XXXX```, where the first six digits ```XXXXXX``` correspond to the document ID; the four digits ```XXXX``` after the dash correspond to a number assigned to each token in the document. These are sequentially ordered through the document. However, to provide flexibility for the insertion of extra tokens in future, token IDs have a trailing ```0```, giving 9 extra IDs on each side for new tokens. (It is, of course, highly unlikely that all this extra space will be needed.)





## Running locally

- Clone the repository:

```
git clone https://github.com/rsdc2/ISicID.git
```

- Open ```index.html``` in a browser

## Building locally

The ID resolver is written in [PureScript]{https://www.purescript.org/}, a functional programming language similar to [Haskell]{https://www.haskell.org/}.
To build and run locally:

```
git clone https://github.com/rsdc2/ISicID.git
cd ISicID
npm install
npx spago bundle-app
```