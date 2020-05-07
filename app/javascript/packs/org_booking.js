import flatpickr from 'flatpickr';

document.addEventListener("turbolinks:load", () => {
	const toggleDateInputs = function() {
		const startDateInput = $('#org_booking_start_time')[0];
		const endDateInput = $('#org_booking_end_time')[0];

	  if (startDateInput && endDateInput) {
	    const unvailableDates = JSON.parse(document.querySelector('.ad-content').dataset.unavailable)

	    flatpickr(startDateInput, {
	    	minDate: 'today',
	    	dateFormat: "Y-m-d",
	    	disable: unvailableDates,
	    	onChange: function(selectedDates, selectedDate) {
	      	if (selectedDate === '') {
	        	endDateInput.disabled = true;
	      	}
	      	let minDate = selectedDates[0];
	      	minDate.setDate(minDate.getDate() + 1);
	      	endDateCalendar.set('minDate', minDate);
	      	endDateInput.disabled = false;
	    	}
	  	});
	    
	    const endDateCalendar =
	      flatpickr(endDateInput, {
	        dateFormat: "Y-m-d",
	        disable: unvailableDates,
	        },
	      );
	  }
	};
	toggleDateInputs();
});
