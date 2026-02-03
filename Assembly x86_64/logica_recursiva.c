int binpow ( int base, int expoente ) {
    // caso base:
    if ( expoente == 1 ) return 1;

    // passo recursivo:
    int res = binpow (base, expoente >> 1 );
    
    res = res * res;

    if ( expoente & 1 ) {
        res = res * base;
    }

    
    return res;
}