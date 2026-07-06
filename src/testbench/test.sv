class ram_test;

  virtual ram_if drv_vif;
  virtual ram_if mon_vif;
  virtual ram_if ref_vif;

  ram_environment env;



  function new(
      virtual ram_if drv_vif,
      virtual ram_if mon_vif,
      virtual ram_if ref_vif
  );

    this.drv_vif = drv_vif;
    this.mon_vif = mon_vif;
    this.ref_vif = ref_vif;

  endfunction



  task run();

    env = new(drv_vif, mon_vif, ref_vif);

    env.build();

    env.start();
  endtask

endclass

  endtask

