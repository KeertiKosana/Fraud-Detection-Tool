import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MlalgorithmResultsComponent } from './mlalgorithm-results.component';

describe('MlalgorithmResultsComponent', () => {
  let component: MlalgorithmResultsComponent;
  let fixture: ComponentFixture<MlalgorithmResultsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MlalgorithmResultsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MlalgorithmResultsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
