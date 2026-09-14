test('simulando falha no CI', () => {
    expct(1).toBE(2); // Isso vai quebrar porque 1 não é igual a 2
});