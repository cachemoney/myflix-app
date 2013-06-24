jQuery(function($) {
  $('#payment-form').submit(function(e) {
    var $form = $(this);
    $form.find('.payment_submit').prop('disabled', true);
    Stripe.card.createToken({
	    number: $('.card-number').val(),
	    cvc: $('.card-cvc').val(),
	    exp_month: $('.card-expiry-month').val(),
	    exp_year: $('.card-expiry-year').val()
		}, stripeResponseHandler);
    return false;
  });

var stripeResponseHandler = function stripeResponseHandler(status, response) {
	var $form = $('#payment-form');

    if (response.error) {
      $form.find(".payment-errors").text(response.error.message);
      $form.find(".payment_submit").prop('disabled', false);
  } else {
      // token contains id, last4, and card type
      var token = response['id'];
      // insert the token into the form so it gets submitted to the server
      $form.append($("<input type='hidden' name='stripeToken' />").val(token));
      // and submit
      $form.get(0).submit();
    }
	};
});