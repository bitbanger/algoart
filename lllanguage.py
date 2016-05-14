import numpy as np
import math

# LLL algo

# Gram-Schmidt orthogonalization is a subroutine
def gram_schmidt( basis ):
	
   if (len(basis) < len(basis[0])):
      print "Small basis set, vector space is underspecified."
	
   dim = len(basis)
   ortho_basis = []
     
   for i in range(dim):
     	
      new_vector = basis[i]	
     	
      for j in range(i):
         # project the current vector along the next vector in
         # the basis
         proj = np.dot(basis[i], ortho_basis[j])
         mag_sq =  np.dot(ortho_basis[j], ortho_basis[j])
         mu = proj / mag_sq
         # substract out the component of the basis vector in 
         # the current vector 
         new_vector = new_vector - mu*ortho_basis[j]
     	
      # new_vector now has all basis vector components "removed"
      # so will be orthogonal (so long as it was not already a 
      # linear combination of basis vectors)
      # Normalize and add to new basis if not the 0 vector
      norm_factor = math.sqrt( np.dot(new_vector, new_vector) )
      if (norm_factor > 0):
         new_vector /= norm_factor
         ortho_basis.append(new_vector)
	 print ortho_basis
   return ortho_basis

x = np.array([2.0, 1.0, 0.0])
y = np.array([0.0, 2.0, 1.0])
z = np.array([0.0, 1.0, 0.25])
print gram_schmidt([x, y, z])

x = np.array([1.0, 0.0, 0.0])
y = np.array([1.0, 1.0, 0.0])
z = np.array([1.0, 1.0, 1.0])
a = np.array([2.0, 5.2, 6.0])
print gram_schmidt([x, y, z, a])			
