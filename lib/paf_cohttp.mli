module type PAF = sig
  type stack

  val tcp_edn : (stack * Ipaddr.t * int) Mimic.value

  val tls_edn :
    ([ `host ] Domain_name.t option
    * Tls.Config.client
    * stack
    * Ipaddr.t
    * int)
    Mimic.value

  val request :
    ?config:Httpaf.Config.t ->
    ctx:Mimic.ctx ->
    error_handler:
      (Mimic.flow ->
      (Ipaddr.t * int) option ->
      Httpaf.Client_connection.error_handler) ->
    response_handler:
      ((Ipaddr.t * int) option -> Httpaf.Client_connection.response_handler) ->
    Httpaf.Request.t ->
    ([ `write ] Httpaf.Body.t, [> Mimic.error ]) result Lwt.t
end

module type S = sig
  type stack

  include Cohttp_lwt.S.Client with type ctx = Mimic.ctx

  val scheme : [ `HTTP | `HTTPS ] Mimic.value

  val port : int Mimic.value

  val domain_name : [ `host ] Domain_name.t Mimic.value

  val ipaddr : Ipaddr.t Mimic.value

  val tcp_edn : (stack * Ipaddr.t * int) Mimic.value

  val tls_edn :
    ([ `host ] Domain_name.t option
    * Tls.Config.client
    * stack
    * Ipaddr.t
    * int)
    Mimic.value

  val with_uri : Uri.t -> Mimic.ctx -> Mimic.ctx
end

module Make (Paf : PAF) : S with type stack = Paf.stack
