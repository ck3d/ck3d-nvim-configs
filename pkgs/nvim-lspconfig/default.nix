{ vimPlugins
, fetchpatch
}: vimPlugins.nvim-lspconfig.overrideAttrs (self: {
  patches = (self.patches or []) ++ [
    (fetchpatch {
      url = "https://github.com/ck3d/nvim-lspconfig/commit/70a13b19ea8e664f8d01b50f7580eb544856aa63.patch";
      hash = "sha256-T+PFmifSrm0s3NnkDKzdcC3x8Zcn8K5fnT9w5MWOGqY=";
    })
  ];
})
