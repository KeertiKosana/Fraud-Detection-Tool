import {AfterViewInit, ChangeDetectorRef, Component, OnInit} from '@angular/core';
import {SkyWaitService} from '@blackbaud/skyux/dist/core';

import {HeaderService} from './services/header.service';
import {JsonService} from './services/json.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  providers: [HeaderService, JsonService],
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit, AfterViewInit {
  isLoading: boolean = true;

  constructor(
      private waitSvc: SkyWaitService,
      private changeDetector: ChangeDetectorRef) {}

  ngOnInit() {
    this.isLoading = true;
    this.waitSvc.beginBlockingPageWait();
  }

  ngAfterViewInit() {
    this.isLoading = false;
    setTimeout(_ => this.waitSvc.endBlockingPageWait(), 1000);
    this.changeDetector.detectChanges();
  }
}
