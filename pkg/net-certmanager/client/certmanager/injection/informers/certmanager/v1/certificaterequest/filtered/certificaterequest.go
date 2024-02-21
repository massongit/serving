/*
Copyright 2022 The Knative Authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// Code generated by injection-gen. DO NOT EDIT.

package filtered

import (
	context "context"

	controller "knative.dev/pkg/controller"
	injection "knative.dev/pkg/injection"
	logging "knative.dev/pkg/logging"
	v1 "knative.dev/serving/pkg/net-certmanager/client/certmanager/informers/externalversions/certmanager/v1"
	filtered "knative.dev/serving/pkg/net-certmanager/client/certmanager/injection/informers/factory/filtered"
)

func init() {
	injection.Default.RegisterFilteredInformers(withInformer)
}

// Key is used for associating the Informer inside the context.Context.
type Key struct {
	Selector string
}

func withInformer(ctx context.Context) (context.Context, []controller.Informer) {
	untyped := ctx.Value(filtered.LabelKey{})
	if untyped == nil {
		logging.FromContext(ctx).Panic(
			"Unable to fetch labelkey from context.")
	}
	labelSelectors := untyped.([]string)
	infs := []controller.Informer{}
	for _, selector := range labelSelectors {
		f := filtered.Get(ctx, selector)
		inf := f.Certmanager().V1().CertificateRequests()
		ctx = context.WithValue(ctx, Key{Selector: selector}, inf)
		infs = append(infs, inf.Informer())
	}
	return ctx, infs
}

// Get extracts the typed informer from the context.
func Get(ctx context.Context, selector string) v1.CertificateRequestInformer {
	untyped := ctx.Value(Key{Selector: selector})
	if untyped == nil {
		logging.FromContext(ctx).Panicf(
			"Unable to fetch knative.dev/serving/pkg/net-certmanager/client/certmanager/informers/externalversions/certmanager/v1.CertificateRequestInformer with selector %s from context.", selector)
	}
	return untyped.(v1.CertificateRequestInformer)
}
