function N = normalize(M)

N = M-min(min(M));
N = N/max(max(N));

end