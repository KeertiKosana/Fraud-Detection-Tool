import {HttpClientModule} from '@angular/common/http';
import {NgModule} from '@angular/core';
import {FormsModule} from '@angular/forms';
import {BrowserModule} from '@angular/platform-browser';
import {SkyModule} from '@blackbaud/skyux/dist/core';

import {AppComponent} from './app.component';
import {CommonResultsComponent} from './common-results/common-results.component';
import {DataCardComponent} from './data-card/data-card.component';
import {DatabaseGridComponent} from './database-grid/database-grid.component';
import {HeaderComponent} from './header/header.component';
import {MetricsComponent} from './metrics/metrics.component';
import {MlalgorithmResultComponent} from './mlalgorithm-result/mlalgorithm-result.component';
import {MlalgorithmResultsComponent} from './mlalgorithm-results/mlalgorithm-results.component';
import {SpecialUseCaseResultsComponent} from './special-use-case-results/special-use-case-results.component';

@NgModule({
  declarations: [
    AppComponent, HeaderComponent, MetricsComponent,
    MlalgorithmResultsComponent, MlalgorithmResultComponent,
    SpecialUseCaseResultsComponent, DatabaseGridComponent, DataCardComponent,
    SpecialUseCaseResultsComponent, DatabaseGridComponent,
    CommonResultsComponent
  ],
  imports: [FormsModule, BrowserModule, HttpClientModule, SkyModule],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule {
}
