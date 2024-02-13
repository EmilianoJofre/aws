import { extend } from 'vee-validate';
import { required, email } from 'vee-validate/dist/rules';
import { rutValidator } from 'vue-dni';

extend('required', { ...required, message: 'required' });
extend('email', { ...email, message: 'email' });
extend('phone', { validate: value => /^\+569(?:\s*\d){7}\d$/.test(value), message: 'phone' });
extend('rut', rutValidator);
