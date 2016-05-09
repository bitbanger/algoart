import spacy
import numpy as np

nlp = spacy.load('en')

text = open('sample_text.txt').read()
doc = nlp(text)

# LLL algo

# Gram-Schmidt orthogonalization is a subroutine
def gram_schmidt( basis ):
	dim = len(basis)

	# the first basis vector is assumed as a member of the
	# orthonormal basis
	ortho_basis = [basis[0]]

	for i in range(dim):
		for j in range(i):
			mu = np.dot( basis[i], basis[j])
			mag = np.dot( basis[i], basis[i] )	
