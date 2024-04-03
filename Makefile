make:
	nix build --option substituters https://mirror.sjtu.edu.cn/nix-channels/store
	xdg-open result 

clean:
	rm *aux *out
